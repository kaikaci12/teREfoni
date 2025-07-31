export function validateUser(req, res, next) {
    const { name, surname,  phone_number, email, password } = req.body;
  
    if (!name || name.trim().length < 2) {
      return res.status(400).json({ message: "Name is required and must be at least 2 characters." });
    }
  
    if (!surname || surname.trim().length < 2) {
      return res.status(400).json({ message: "Surname is required and must be at least 2 characters." });
    }
  
    if (!id_number || !/^\d{11}$/.test(id_number)) {
      return res.status(400).json({ message: "ID number must be exactly 11 digits." });
    }
  
    if (!phone_number || !/^\+?\d{9,15}$/.test(phone_number)) {
      return res.status(400).json({ message: "Phone number is invalid." });
    }
  
    if (!email || !/^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email)) {
      return res.status(400).json({ message: "Invalid email address." });
    }
  
    if (!password || password.length < 6) {
      return res.status(400).json({ message: "Password must be at least 6 characters." });
    }
  
    next(); // ✅ Validation passed, continue to controller
  }
  