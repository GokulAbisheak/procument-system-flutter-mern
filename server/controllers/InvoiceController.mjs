// Import necessary modules
import Invoice from "../models/Invoice.mjs";
import logger from "../utils/logger.mjs";

// Handler function to generate and save a new invoice based on request data.
export const generateInvoice = async (req, res) => {
  // Destructure and extract invoice details from the request body.
  const {
    orderId,
    empId,
    item,
    quantity,
    pricePerUnit,
    totalAmount,
    accountantId,
    accountantEmail,
  } = req.body;

  try {
    // Create a new invoice instance with the provided data and the current date.
    const newInvoice = new Invoice({
      orderId,
      empId,
      item,
      quantity,
      pricePerUnit,
      totalAmount,
      accountantId,
      accountantEmail,
      issuedDate: new Date(),
    });

    // Save the invoice to the database.
    const savedInvoice = await newInvoice.save();

    // Log the successful creation of the invoice.
    logger.info(`Invoice generated successfully with ID: ${savedInvoice._id}`);

    // Return the saved invoice as the response.
    res.json(savedInvoice);
  } catch (error) {
    // Log any error that occurs during the invoice generation process.
    logger.error(`Failed to generate invoice: ${error.message}`);

    // Return an internal server error response.
    res.status(500).json({ status: "Error", message: "Internal server error" });
  }
};

// Handler function to retrieve all invoices associated with a specific accountant.
export const getInvoicesByAccountant = async (req, res) => {
  // Extract the accountant's ID from the request parameters.
  const accountantId = req.params.accountantId;

  try {
    // Query the database to find all invoices associated with the provided accountant ID.
    const invoices = await Invoice.find({ accountantId: accountantId });

    // Check if there are any invoices for the accountant.
    if (invoices.length > 0) {
      logger.info(
        `Retrieved ${invoices.length} invoices for accountant ID: ${accountantId}`
      );
      res.json(invoices);
    } else {
      logger.warn(`No invoices found for accountant ID: ${accountantId}`);
      res
        .status(404)
        .json({
          status: "Error",
          message: "No invoices found for the accountant",
        });
    }
  } catch (err) {
    logger.error(
      `Failed to retrieve invoices for accountant ID ${accountantId}: ${err.message}`
    );
    res.status(500).json({ status: "Error", message: "Internal server error" });
  }
};

// Handler function to update the status of an invoice.
export const updateStatus = async (req, res) => {
  // Extract invoice ID and the new status from the request.
  const { invoiceId } = req.params;
  const { invoiceStatus } = req.body;

  try {
    // Update the status of the invoice in the database.
    const updatedInvoice = await Invoice.findByIdAndUpdate(
      invoiceId,
      { invoiceStatus },
      { new: true }
    );

    // If the invoice isn't found, return a not found error.
    if (!updatedInvoice) {
      logger.warn(`Invoice with ID ${invoiceId} not found for status update.`);
      return res.status(404).json({ message: "Invoice not found" });
    }

    // Log the successful update and return the updated invoice.
    logger.info(`Updated invoice status for ID: ${invoiceId}`);
    return res.status(200).json(updatedInvoice);
  } catch (error) {
    logger.error(
      `Error updating invoice status for ID ${invoiceId}: ${error.message}`
    );
    return res.status(500).json({ message: "Internal server error" });
  }
};

// Handler function to fetch the details of an invoice by its ID.
export const getInvoiceDetailsById = async (req, res) => {
  // Extract the invoice ID from the request parameters.
  const invoiceId = req.params.invoiceId;

  try {
    // Query the database to get the details of the specified invoice.
    const invoice = await Invoice.findById(invoiceId);

    // If the invoice isn't found, return a not found error.
    if (!invoice) {
      logger.warn(`Invoice with ID ${invoiceId} not found.`);
      return res.status(404).json({ message: "Invoice not found" });
    }

    // Log the successful retrieval and return the invoice details.
    logger.info(`Retrieved invoice details for ID: ${invoiceId}`);
    res.json(invoice);
  } catch (error) {
    logger.error(
      `Failed to retrieve invoice details for ID ${invoiceId}: ${error.message}`
    );
    return res.status(500).json({ message: "Internal server error" });
  }
};
