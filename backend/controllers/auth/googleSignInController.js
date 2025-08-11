import { OAuth2Client } from "google-auth-library";
import client from "../../config/db.js";
import { generateAccessToken, generateRefreshToken } from "../../utils/tokenGenerator.js";

// Initialize the Google OAuth2 client with your web client ID.
// This is the public ID from the Google Cloud Console.
const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

export const googleSignInController = async (req, res) => {
  try {
    const { idToken } = req.body;

    if (!idToken) {
      return res.status(400).json({ message: "ID token is missing" });
    }

    // Verify the ID token and get the payload
    const ticket = await googleClient.verifyIdToken({
      idToken: idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });
    
    // The payload contains the user's data from their Google account
    const payload = ticket.getPayload();
    const googleId = payload.sub;
    const email = payload.email;
    const firstName = payload.given_name;
    const lastName = payload.family_name;

    // Check if a user with this Google ID already exists
    const findUserQuery = 'SELECT * FROM users WHERE google_id = $1';
    let userResult = await client.query(findUserQuery, [googleId]);

    let user;

    if (userResult.rows.length === 0) {
      // If the user doesn't exist, create a new user entry
      const createTableQuery = `
      CREATE TABLE IF NOT EXISTS users (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      google_id VARCHAR(255) UNIQUE,
      first_name VARCHAR(255) NOT NULL,
      last_name VARCHAR(255) NOT NULL,
      phone_number VARCHAR(20) UNIQUE,
      email VARCHAR(255) UNIQUE,
      password TEXT, 
      created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
  );
      `;
      await client.query(createTableQuery);
  
      const createRefreshTableQuery = `
      CREATE TABLE IF NOT EXISTS refresh_tokens (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id UUID REFERENCES users(id) ON DELETE CASCADE,
      token TEXT NOT NULL,
      expires_at TIMESTAMPTZ NOT NULL,
      created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
  );
      `;
      await client.query(createRefreshTableQuery);
      const insertUserQuery = `
        INSERT INTO users (google_id, first_name, last_name, email, phone_number, password)
        VALUES ($1, $2, $3, $4, $5)
        RETURNING id, first_name, last_name, email;
      `;
      const userValues = [googleId, firstName, lastName, email,   null]; // Password is null for social login
      userResult = await client.query(insertUserQuery, userValues);
    }
    
    user = userResult.rows[0];
    
    // Generate access and refresh tokens for the user
    const userId = user.id;
    const accessToken = generateAccessToken(userId);
    const refreshToken = generateRefreshToken(userId);
    const expiresAt = new Date(Date.now() + 1000 * 60 * 60 * 24 * 14); // 14 days

    // Insert the new refresh token into the database
    const insertRefreshQuery = `
      INSERT INTO refresh_tokens (user_id, token, expires_at)
      VALUES ($1, $2, $3);
    `;
    await client.query(insertRefreshQuery, [userId, refreshToken, expiresAt]);

    // Set the refresh token as an httpOnly cookie for web clients
    res.cookie("refreshToken", refreshToken, {
      httpOnly: true,
      secure: process.env.NODE_ENV !== "development",
      sameSite: "Strict",
      maxAge: 1000 * 60 * 60 * 24 * 14,
    });
    
    console.log("Successfull Google Sign In. User:",user)
    // Send the user info and access token back to the client
    return res.status(200).json({
      message: "Sign-in successful",
      user: {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
      },
      accessToken,
      refreshToken, // Send refresh token for mobile clients to save
    });
  } catch (error) {
    console.error(error.message);
    return res.status(500).json({ message: "Something went wrong" });
  }
};