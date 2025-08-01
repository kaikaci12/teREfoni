import express from "express";
import dotenv from 'dotenv'
import usersRegisterRoute from "./routes/auth/register.js"
import usersLoginRoute from "./routes/auth/login.js"
import refreshTokenRoute from "./routes/auth/refresh.js"
import cors from "cors"
dotenv.config()
const PORT = process.env.PORT || 3000
const app = express()
app.use(express.json())
app.use(express.urlencoded({ extended: true }));
app.use(cors())
app.use("/api/auth",usersRegisterRoute)
app.use("/api/auth",usersLoginRoute)
app.use("/api/auth",refreshTokenRoute)
app.listen(PORT,()=>{
    console.log("Server is running on PORT",PORT)
})
