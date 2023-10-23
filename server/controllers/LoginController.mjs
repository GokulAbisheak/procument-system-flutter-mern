// Import necessary modules and utilities
import User from "../models/User.mjs";
import logger from "../utils/logger.mjs";
import bcrypt from "bcrypt";

// Define the LoginController
const LoginController = {
  // Define the login method
  Login: async (req, res) => {
    // Destructure and extract employee ID and password from request body
    const { empId, password } = req.body;

    try {
      // Try to fetch the user from the database using the employee ID
      const user = await User.findOne({ empId: empId });

      // Log the retrieved user (for debugging purposes)
      console.log(user);

      if (user) {
        // If a user with the provided employee ID is found, compare the entered password with the stored password hash
        bcrypt.compare(password, user.password, (err, response) => {
          if (response) {
            // If the password matches, check the user role and respond accordingly
            if (user.role == "procurement")
              res.json({ type: "procurement", user });
            else if (user.role == "accountant")
              res.json({ type: "accountant", user });
            else if (user.role == "senior") res.json({ type: "senior", user });
            else if (user.role == "supplier")
              res.json({ type: "supplier", user });
          } else {
            // If the password doesn't match, send an error response
            res.json("Invalid Password");
          }
        });
      }
    } catch (e) {
      // If there's any error during the process, send a generic error response
      res.json("No");
    }
  },
};

// Export the LoginController
export default LoginController;
