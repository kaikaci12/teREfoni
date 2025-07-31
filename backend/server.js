import express from "express";
import dotenv from 'dotenv'
import usersRoute from "./routes/auth/register.js"
import cors from "cors"
dotenv.config()
const PORT = process.env.PORT || 3000
const app = express()
app.use(express.json())
app.use(express.urlencoded({ extended: true }));
app.use(cors())
app.use("/api/auth",usersRoute,)

app.listen(PORT,()=>{
    console.log("Server is running on PORT",PORT)
})
