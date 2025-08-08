import client from "../../config/db.js";

export const logoutUser = async (req, res) => {
  const refreshToken = req.refreshToken;
 
  console.log('Logout attempt for token:', refreshToken ? 'Token present' : 'No token');
 
  // deleting refreshToken from db
  try {
    const result = await client.query(`DELETE FROM refresh_tokens WHERE token=$1 RETURNING *`, [refreshToken]);
    
    // Clear the cookie regardless of whether token was found in DB
    res.clearCookie("refreshToken", {
      httpOnly: true,
      secure: process.env.NODE_ENV !== "development",
      sameSite: "Strict",
    });
    
    if (result.rowCount === 0) {
      console.log('Token not found in database, but clearing cookie anyway');
      // Even if token not found in DB, consider logout successful
      // (token might have expired or been already deleted)
      return res.status(200).json({ message: "Logged out successfully" });
    }

    console.log('Token successfully deleted from database');
    return res.status(200).json({ message: "Logged out successfully" });

  } catch (error) {
    console.error("Logout Error: ", error.message);
    // Even if there's an error, clear the cookie and return success
    res.clearCookie("refreshToken", {
      httpOnly: true,
      secure: process.env.NODE_ENV !== "development",
      sameSite: "Strict",
    });
    return res.status(200).json({ message: "Logged out successfully" });
  } 
}; 