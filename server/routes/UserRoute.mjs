// Import controller methods related to User management
import { createUser, getAllUser } from "../controllers/UserController.mjs";

// Import necessary modules from Express for routing
import Router from "express";

// Initialize the router from the Express library
const UserRouter = Router();

// Route to handle POST request to create a new user
// Calls the 'createUser' function from UserController
UserRouter.post("/add", createUser);

// Route to handle GET request to retrieve all users
// Calls the 'getAllUser' function from UserController
UserRouter.get("/get-all", getAllUser);

// Export the UserRouter to be used in other parts of the application
export default UserRouter;
