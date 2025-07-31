// db.js (or config/database.js) - It's good practice to separate DB connection
import { Client} from "pg"
import dotenv from "dotenv"
dotenv.config()
const client = new Client({
  user: "postgres",
  password: process.env.DATABASE_PASSWORD,
  host: "localhost",
  port: 5432,
  database: "terefoni_db",
});

client.connect()
  .then(() => console.log("✔️ Database connected successfully"))
  .catch(e => console.error("🚫 Database connection error:", e));

export default client
// ort the client so other modules can use it
