import * as bcrypt from "bcrypt"
import client from "../../config/db.js";
import { generateAccessToken, generateRefreshToken } from "../../utils/tokenGenerator.js";

export const registerUser = async (req, res) => {
  try {
    const { first_name, last_name, phone_number, email, password } = req.body;

    const hashedPassword = await bcrypt.hash(password, 11);

    // Create tables if not exists (you can do this elsewhere in app startup ideally)
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

    // Insert user
    const userInsertQuery = `
      INSERT INTO users (first_name, last_name, phone_number, email, password)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING *;
    `;
    const userValues = [first_name, last_name, phone_number || null, email || null, hashedPassword];
    const result = await client.query(userInsertQuery, userValues);
    const user = result.rows[0];

    // Generate tokens
    const userId = user.id;
    const accessToken = generateAccessToken(userId);
    const refreshToken = generateRefreshToken(userId);
    const expiresAt = new Date(Date.now() + 1000 * 60 * 60 * 24 * 14); // 14 days

    const refreshInsertQuery = `
      INSERT INTO refresh_tokens (user_id, token, expires_at)
      VALUES ($1, $2, $3);
    `;
    await client.query(refreshInsertQuery, [userId, refreshToken, expiresAt]);

    res.cookie("refreshToken", refreshToken, {
      httpOnly: true,
      secure: process.env.NODE_ENV !== "development",
      sameSite: "Strict",
      maxAge: 1000 * 60 * 60 * 24 * 14,
    });

    return res.status(201).json({
      message: "User added successfully",
      user: {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        phone_number: user.phone_number,
        email: user.email,
      },
      accessToken,
      refreshToken //mobile will store this in secure_storage
    });

  } catch (err) {
    console.error(err.message);

    // Handle unique constraint violation
    if (err.code === "23505") {
      // Parse which field caused the violation
      if (err.detail.includes("phone_number")) {
        return res.status(409).json({ message: "Phone number already in use." });
      }
      if (err.detail.includes("email")) {
        return res.status(409).json({ message: "Email already in use." });
      }
      // Generic message if unknown
      return res.status(409).json({ message: "User with provided data already exists." });
    }

    return res.status(500).json({ message: "Something went wrong" });
  }
};
