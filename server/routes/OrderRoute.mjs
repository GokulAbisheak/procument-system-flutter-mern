// Import necessary modules
import Route from "express";
import {
  generateInvoice,
  getInvoicesByAccountant,
  updateStatus,
  getInvoiceDetailsById,
} from "../controllers/InvoiceController.mjs";

// Initialize the router from Express
const InvoiceRouter = Route();

// Route to handle POST request to add a new invoice
// Calls the 'generateInvoice' function from InvoiceController
InvoiceRouter.post("/add-invoice", generateInvoice);

// Route to handle GET request to retrieve all invoices associated with a specific accountant
// Calls the 'getInvoicesByAccountant' function from InvoiceController
InvoiceRouter.get("/get-invoices/:accountantId", getInvoicesByAccountant);

// Route to handle PUT request to update the status of a specific invoice
// Calls the 'updateStatus' function from InvoiceController
InvoiceRouter.put("/update-invoice-status/:invoiceId", updateStatus);

// Route to handle GET request to retrieve details of a specific invoice by its ID
// Calls the 'getInvoiceDetailsById' function from InvoiceController
InvoiceRouter.get("/get-invoice-id/:invoiceId", getInvoiceDetailsById);

// Export the InvoiceRouter to be used in other parts of the application
export default InvoiceRouter;
