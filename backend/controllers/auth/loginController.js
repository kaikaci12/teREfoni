import * as bcrypt from "bcrypt";
import client from "../../config/db.js";
import { generateAccessToken, generateRefreshToken } from "../../utils/tokenGenerator.js";

export const loginUser = async (req, res) => {
  try {
    const { email, phone_number, password } = req.body;

    let userQuery = "";
    let identifierValue = "";
    
    if (email) {
      userQuery = "SELECT * FROM users WHERE email = $1";
      identifierValue = email;
    } else if (phone_number) {
      userQuery = "SELECT * FROM users WHERE phone_number = $1";
      identifierValue = phone_number;
    } else {
      return res.status(400).json({ message: "Either email or phone number is required." });
    }
    
    const result = await client.query(userQuery, [identifierValue]);
    const user = result.rows[0];

    // ⚠️ Handle "user not found"
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const hashedPassword = user.password;

    const matches = await bcrypt.compare(password, hashedPassword);
    if (!matches) {
      return res.status(401).json({ message: "Incorrect password" });
    }

    const userId = user.id;
    const accessToken = generateAccessToken(userId);
    const refreshToken = generateRefreshToken(userId);
    const expiresAt = new Date(Date.now() + 1000 * 60 * 60 * 24 * 14); // 14 days

    // ✅ Insert refresh token into DB (write the insert query here)
    const refreshInsertQuery = `
      INSERT INTO refresh_tokens (user_id, token, expires_at)
      VALUES ($1, $2, $3)
      ON CONFLICT (user_id)
      DO UPDATE SET token = EXCLUDED.token, expires_at = EXCLUDED.expires_at
    `;
    await client.query(refreshInsertQuery, [userId, refreshToken, expiresAt]);

    res.cookie("refreshToken", refreshToken, {
      httpOnly: true,
      secure: process.env.NODE_ENV !== "development",
      sameSite: "Strict",
      maxAge: 1000 * 60 * 60 * 24 * 14,
    });

    // ✅ Send access + refresh tokens in response
    return res.status(201).json({
      message: "Successful Login",
      user: {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        phone_number: user.phone_number,
        email: user.email,
      },
      accessToken,
      refreshToken, // Used by mobile app to store in secure storage
    });

  } catch (error) {
    console.error(error.message);
    return res.status(500).json({ message: "Something went wrong" });
  }
}; 