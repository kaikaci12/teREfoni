import bcrypt from "bcrypt";

// Registration Validator
export function validateUserRegister(req, res, next) {
  const { first_name, last_name, phone_number, email, password } = req.body;

  if (!first_name || first_name.trim().length < 2) {
    return res.status(400).json({ message: "First name must be at least 2 characters." });
  }

  if (!last_name || last_name.trim().length < 2) {
    return res.status(400).json({ message: "Last name must be at least 2 characters." });
  }

  if (!phone_number && !email) {
    return res.status(400).json({ message: "Either email or phone number is required." });
  }

  if (phone_number && !/^5\d{8}$/.test(phone_number)) {
    return res.status(400).json({ message: "Phone number must start with '5' and be 9 digits long." });
  }

  if (email && !/^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email)) {
    return res.status(400).json({ message: "Invalid email address." });
  }

  if (!password || password.length < 6) {
    return res.status(400).json({ message: "Password must be at least 6 characters." });
  }

  next(); // ✅ All validations passed
}

// Login Validator (email or phone_number)
export function validateUserLogin(req, res, next) {
  const { email, phone_number, password } = req.body;

  if ((!email && !phone_number) || !password) {
    return res.status(400).json({ message: "Email or phone number and password are required." });
  }

  if (phone_number && !/^5\d{8}$/.test(phone_number)) {
    return res.status(400).json({ message: "Invalid phone number format." });
  }

  if (email && !/^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email)) {
    return res.status(400).json({ message: "Invalid email format." });
  }

  next(); // ✅ All validations passed
}
