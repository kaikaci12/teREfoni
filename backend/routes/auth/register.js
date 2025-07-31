import express from "express"
import * as bcrypt from "bcrypt"
import client from "../../config/db.js"
import { validateUser } from "../../middlewares/validator/validateUser.js"
import { generateAccessToken, generateRefreshToken } from "../../utils/tokenGenerator.js"
const router = express.Router()


router.post("/", validateUser, async (request, response) => {
  try {
    const { first_name, last_name, phone_number, email, password } = request.body;

    const hashedPassword = await bcrypt.hash(password, 11);

    const userInsertQuery = `
      INSERT INTO users (first_name, last_name, phone_number, email, password)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING *;
    `;

    const userValues = [first_name, last_name, phone_number, email, hashedPassword];
    const result = await client.query(userInsertQuery, userValues);
    const user = result.rows[0];

    const userId = user.id;
    const accessToken = generateAccessToken(userId);
    const refreshToken = generateRefreshToken(userId);

    // Save refresh token in DB
    const refreshInsertQuery = `
      INSERT INTO refresh_tokens (user_id, token, expires_at)
      VALUES ($1, $2, $3);
    `;
    const expiresAt = new Date(Date.now() + 1000 * 60 * 60 * 24 * 14); // 14 days

    await client.query(refreshInsertQuery, [userId, refreshToken, expiresAt]);

 
    response.cookie("refreshToken", refreshToken, {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "Strict",
      maxAge: 1000 * 60 * 60 * 24 * 14,
    });

    return response.status(201).json({
      message: "User added successfully",
      user: {
        id: user.id,
        name: user.name,
        last_name: user.last_name,
        phone_number: user.phone_number,
        email: user.email,
      },
      accessToken,
      refreshToken //mobile will store this in secure_storage
    });
  } catch (err) {
    console.error(err.message);
    return response.status(500).json({ message: "Something went wrong" });
  }
});

export default router;
