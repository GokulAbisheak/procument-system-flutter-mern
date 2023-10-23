// Import necessary modules
import LoginController from "../controllers/LoginController.mjs";
import express from "express";

// Initialize the router from the Express library
const LoginRouter = express.Router();

// Route to handle POST request for user login
// Calls the 'Login' method from LoginController
LoginRouter.post("/", LoginController.Login);

// Export the LoginRouter to be used in other parts of the application
export default LoginRouter;
