import express from "express";
import dotenv from 'dotenv';
import authRoutes from "./routes/auth/auth.js";
import cors from "cors";
import cookieParser from "cookie-parser";

dotenv.config();

const PORT = process.env.PORT || 3000;
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());

// Configure CORS properly for cookies - allow multiple origins for development
const allowedOrigins = [
  
  "http://localhost:8080",    // Flutter web default

  process.env.FRONTEND_URL,   // Environment variable
].filter(Boolean); // Remove undefined values

app.use(cors({
  origin: function (origin, callback) {
    // Allow requests with no origin (like mobile apps or curl requests)
    if (!origin) return callback(null, true);
    
    // Allow any localhost origin for development
    if (origin.startsWith('http://localhost:') || origin.startsWith('https://localhost:')) {
      console.log('CORS allowed origin:', origin);
      return callback(null, true);
    }
    
    if (allowedOrigins.indexOf(origin) !== -1) {
      callback(null, true);
    } else {
      console.log('CORS blocked origin:', origin);
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true,  // <-- Important: allows cookies to be sent/received
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
}));

// Add a test endpoint
app.get('/api/auth/test', (req, res) => {
  res.json({ message: 'Server is running and accessible!' });
});

app.use("/api/auth", authRoutes);

app.listen(PORT, () => {
  console.log("Server is running on PORT", PORT);
  console.log("Allowed CORS origins:", allowedOrigins);
});
