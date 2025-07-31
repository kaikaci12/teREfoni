import jwt from "jsonwebtoken";

export function generateAccessToken(userId) {
  const payload = {
    sub: userId,
    iat: Math.floor(Date.now() / 1000), // current timestamp in seconds
  };

  const token = jwt.sign(payload, process.env.ACCESS_TOKEN_SECRET, {
    expiresIn: "15m",
  });

  return token;
}

export function generateRefreshToken(userId){
    const payload = {
        sub: userId,
        iat: Math.floor(Date.now() / 1000), // current timestamp in seconds
      };

      const token = jwt.sign(payload, process.env.REFRESH_TOKEN_SECRET, {
        expiresIn: "14d",
      });
    
      return token;
}
