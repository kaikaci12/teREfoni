import express from "express";
import { 
  registerUser, 
  loginUser, 
  logoutUser, 
  refreshToken, 
  googleSignInController
} from "../../controllers/auth/index.js";
import { 
  validateUserRegister, 
  validateUserLogin 
} from "../../middlewares/validator/validateUser.js";
import { verifyRefreshToken } from "../../middlewares/verifyToken.js";

const router = express.Router();

// Register route
router.post("/register", validateUserRegister, registerUser);

// Login route
router.post("/login", validateUserLogin, loginUser);

// Logout route
router.delete("/logout", verifyRefreshToken, logoutUser);

// Refresh token route
router.get("/refresh", verifyRefreshToken, refreshToken);
router.post("/google",googleSignInController)
export default router;
