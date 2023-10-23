// Import the 'express' framework and the required controller functions from the specified paths.
import express from "express";
import {
  addItems,
  getAllPurchaseRequisitions,
  getPurchaseRequisitionById,
  getPurchaseRequisitionByEmpId,
  updateItems,
} from "../controllers/PurchaseRequisitionController.mjs";

// Create an instance of an Express Router.
const route = express.Router();

// Define routes for handling purchase requisitions.

// Route to add purchase requisitions, using the 'addItems' controller function.
route.post("/add-items", addItems);

// Route to get a purchase requisition by its ID, using the 'getPurchaseRequisitionById' controller function.
route.get("/get-pr-by-id/:_id", getPurchaseRequisitionById);

// Route to get all purchase requisitions, using the 'getAllPurchaseRequisitions' controller function.
route.get("/get-all-pr", getAllPurchaseRequisitions);

// Route to get purchase requisitions by employee ID, using the 'getPurchaseRequisitionByEmpId' controller function.
route.get("/get-pr-by-empid/:empId", getPurchaseRequisitionByEmpId);

// Route to update purchase requisitions, using the 'updateItems' controller function.
route.put("/update-items", updateItems);

// Export the router to be used by the application.
export default route;
