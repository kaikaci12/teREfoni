import jwt from "jsonwebtoken"



export function verifyRefreshToken(req, res, next) {
  let token;

  // 1. Try from Authorization header: Bearer <token>
  const authHeader = req.headers.authorization;
  if (authHeader?.startsWith("Bearer ")) {
    token = authHeader.split(" ")[1];
  }

  // 2. Try from cookies (web apps)
  if (!token && req.cookies?.refreshToken) {
    token = req.cookies.refreshToken;
  }

  if (!token) {
    return res.status(401).json({ message: "Unauthorized: No refresh token" });
  }

  jwt.verify(token, process.env.REFRESH_TOKEN_SECRET, (err, decoded) => {
    if (err) {
      return res.status(401).json({ message: "Unauthorized: Invalid token" });
    }

    req.user = decoded;
    req.refreshToken = token
    next();
  });
}

export function verifyAccessToken(req,res,next){
    const authHeader = req.headers.authorization
    const token = authHeader && authHeader.split(" ")[1]
    if(!token) return res.status(401).json({message:"Unauthorized"})
    jwt.verify(token,process.env.ACCESS_TOKEN_SECRET,(err,decoded)=>{
        if(err) return res.status(401).json({message:"Unauthorized"})
        req.user = decoded
        next()
    })
}