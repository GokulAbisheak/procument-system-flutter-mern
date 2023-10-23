// Import the necessary modules
import Accountant from "../models/Accountant.mjs";
import logger from "../utils/logger.mjs";

// Asynchronous function to create a new accountant entry in the system
export const createAccountant = async (req, res) => {
  // Extract the necessary data from the request's body
  const { empId, accountantId, accountantEmail } = req.body;

  try {
    // Initialize a new accountant object using the extracted data
    const newAccountant = new Accountant({
      empId,
      accountantId,
      accountantEmail,
    });

    // Save the new accountant object to the database and await its completion
    const savedAccountant = await newAccountant.save();

    // If successful, log the creation of the new accountant
    logger.info(
      `Accountant created successfully with ID: ${savedAccountant._id}`
    );

    // Return the saved accountant as a response
    res.json(savedAccountant);
  } catch (error) {
    // In case of any error, log it for debugging
    logger.error(`Failed to create accountant: ${error.message}`);

    // Return a 500 status code (Internal Server Error) and the associated error message
    res.status(500).json({ status: "Error", message: "Internal server error" });
  }
};

// Asynchronous function to fetch details of an accountant by their employee ID
export const getAccountantByEmpId = async (req, res) => {
  // Extract the employee ID from the request's parameters
  const { empId } = req.params;

  try {
    // Use the extracted employee ID to search for the accountant in the database
    const accountant = await Accountant.findOne({ empId });

    // If the accountant is found
    if (accountant) {
      // Log the successful retrieval
      logger.info(`Retrieved accountant for employee ID: ${empId}`);

      // Return the accountant's details as a response
      res.json(accountant);
    } else {
      // If no accountant is found for the given employee ID, log the situation
      logger.warn(`No accountant found for employee ID: ${empId}`);

      // Return a 404 status code (Not Found) with an appropriate error message
      res
        .status(404)
        .json({ status: "Error", message: "Accountant not found" });
    }
  } catch (error) {
    // In case of any error, log it for debugging
    logger.error(
      `Failed to retrieve accountant for employee ID ${empId}: ${error.message}`
    );

    // Return a 500 status code (Internal Server Error) and the associated error message
    res.status(500).json({ status: "Error", message: "Internal server error" });
  }
};
