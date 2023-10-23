// Import necessary modules
import { Router } from "express";
import { makePayment } from "../controllers/PaymentController.mjs";

// Initialize the router from the Express library
const PaymentRouter = Router();

// Route to handle POST request to add a new payment
// Calls the 'makePayment' function from PaymentController
PaymentRouter.post("/add-payment", makePayment);

// Export the PaymentRouter to be used in other parts of the application
export default PaymentRouter;
