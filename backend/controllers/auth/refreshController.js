import client from "../../config/db.js";
import { generateAccessToken } from "../../utils/tokenGenerator.js";

export const refreshToken = async (req, res) => {
  const userId = req.user.sub; // You are using JWT's `sub` claim as userId — that's fine
  const refreshToken = req.refreshToken;

  try {
    const result = await client.query(
      `SELECT * FROM refresh_tokens WHERE token = $1`,
      [refreshToken]
    );

    const tokenRecord = result.rows[0];
   
    if (!tokenRecord) {
      return res
        .status(401)
        .json({ message: "Refresh token does not exist or has expired" });
    }

    const newAccessToken = generateAccessToken(userId);

    return res.status(200).json({
      message: "Successfully generated new access token",
      accessToken: newAccessToken,
    });
  } catch (error) {
    console.error("Refresh error:", error.message);
    return res.status(500).json({ message: "Something went wrong" });
  }
}; 