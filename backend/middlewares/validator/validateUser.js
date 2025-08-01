import bcrypt  from "bcrypt"

export function validateUserRegister(req, res, next) {
    const { first_name, last_name,  phone_number, email, password } = req.body;
  
    if (!first_name || first_name.trim().length < 2) {
      return res.status(400).json({ message: "Name is required and must be at least 2 characters." });
    }
  
    if (!last_name || last_name.trim().length < 2) {
      return res.status(400).json({ message: "last_name is required and must be at least 2 characters." });
    }
  
    // if (!id_number || !/^\d{11}$/.test(id_number)) {
    //   return res.status(400).json({ message: "ID number must be exactly 11 digits." });
    // }
  
    if (!phone_number || !/^5\d{8}$/.test(phone_number)
    ) {
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
 export function validateUserLogin(req,res,next){
  const {email,password} = req.body
  if(!email || !password){
    return res.status(400).json({ message: "Credentials not provided" });
  }
 next()

 } 