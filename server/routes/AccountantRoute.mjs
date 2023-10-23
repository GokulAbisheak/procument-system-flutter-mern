// Import the necessary modules
import { Router } from "express";
import {
  createAccountant,
  getAccountantByEmpId,
} from "../controllers/AccountantController.mjs";

// Initialize the router from Express
const AccountantRouter = Router();

// Route to handle POST request to add accountant details
// Calls the 'createAccountant' function from AccountantController
AccountantRouter.post("/add-details", createAccountant);

// Route to handle GET request to retrieve accountant details by employee ID
// Calls the 'getAccountantByEmpId' function from AccountantController
AccountantRouter.get("/get-accountant/:empId", getAccountantByEmpId);

// Export the AccountantRouter to be used in other parts of the application
export default AccountantRouter;
