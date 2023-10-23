// Import necessary modules and utilities
import User from "../models/User.mjs";
import logger from "../utils/logger.mjs";
import bcrypt from "bcrypt";

// Function to create a new user
export const createUser = async (req, res) => {
  // Destructure and extract employee ID, password, and role from request body
  const { empId, password, role } = req.body;

  // Log the received credentials (mainly for debugging purposes)
  console.log(empId + " " + password + " " + role);

  // Hash the received password for security
  const hashedPassword = await bcrypt.hash(password, 12);

  // Use the User model to create a new user entry in the database
  User.create({
    empId,
    password: hashedPassword,
    role,
  })
    .then((User) => {
      // Log the successful user creation for debugging purposes
      console.log({ status: "Success", User });

      // Return the created user's details as the response
      return res.json(User);
    })
    .catch((err) => {
      // Log any error encountered during the process
      console.log({ status: "Error", err });

      // Return an error message as the response
      return res.json({ status: "Error", err });
    });
};

// Function to retrieve all users
export const getAllUser = async (req, res) => {
  // Use the User model to fetch all users from the database
  User.find()
    .then((User) => {
      // Return the list of users as the response
      return res.json(User);
    })
    .catch((err) => {
      // Log any error encountered during the process
      console.log({ status: "Error", err });

      // Return an error message as the response
      return res.json({ status: "Error", err });
    });
};
