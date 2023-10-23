// Import necessary modules
import Payment from "../models/Payment.mjs";
import logger from "../utils/logger.mjs";

// Controller function responsible for processing and saving payment information
export const makePayment = async (req, res) => {
  try {
    // Extract required payment details from the request body
    const { invoiceId, orderId, item, quantity, totalAmount, CardNumber } =
      req.body;

    // Record the current date and time to indicate when the payment was initiated
    const dateTime = new Date();

    // Create a new instance of the Payment model using the extracted details
    const payment = new Payment({
      invoiceId,
      orderId,
      item,
      quantity,
      totalAmount,
      CardNumber,
      dateTime,
    });

    // Save the constructed payment instance to the database
    await payment.save();

    // Log the successful addition of payment for audit or tracking purposes
    logger.info(`Payment for invoice ID ${invoiceId} was added successfully.`);

    // Respond with a status code of 201 (Created) and a success message
    res.status(201).json({ message: "Payment added successfully" });
  } catch (error) {
    // Log the error for further debugging and analysis
    logger.error(`Error encountered while adding payment: ${error.message}`);

    // Send a response with a 500 (Internal Server Error) status code and an error message
    res
      .status(500)
      .json({ message: "Failed to add payment", error: error.message });
  }
};
