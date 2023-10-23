import Order from "../models/Order.mjs";
import logger from "../utils/logger.mjs";

// Function to add items to a purchase requisition
export const addItems = async (req, res) => {
  // Extract purchase requisition and supplier details from the request body
  const { purchaseRequisition, supplier } = req.body;

  try {
    // Create a new order with the provided details
    const order = await Order.create({
      purchaseRequisition,
      supplier,
    });

    // Log the successful order creation for debugging
    logger.info(`Order created successfully with ID: ${order._id}`);

    // Respond with the created order details
    res.json(order);
  } catch (err) {
    // Log the error for debugging
    logger.error(`Error creating order: ${err.message}`);
  }
};

// Function to retrieve all orders for a specific supplier
export const getOrdersBySupplier = async (req, res) => {
  // Extract supplier ID from the request parameters
  const supplierId = req.params.supplierId;

  try {
    // Fetch all orders for the supplier and populate the purchase requisition details
    const orders = await Order.find({ supplier: supplierId }).populate(
      "purchaseRequisition"
    );

    // Check if there are any orders
    if (orders.length > 0) {
      // Log successful retrieval for debugging
      logger.info(
        `Retrieved ${orders.length} orders for supplier ID: ${supplierId}`
      );

      // Respond with the list of orders
      res.json(orders);
    } else {
      // Respond with an error if no orders are found
      logger.warn(`No orders found for supplier ID: ${supplierId}`);
      res
        .status(404)
        .json({ status: "Error", message: "No orders found for the supplier" });
    }
  } catch (err) {
    // Log the error for debugging
    logger.error(
      `Error retrieving orders for supplier ID ${supplierId}: ${err.message}`
    );

    // Respond with an internal server error status
    res.status(500).json({ status: "Error", message: "Internal server error" });
  }
};

// Function to update the status of a specific order
export const updateStatus = async (req, res) => {
  try {
    // Extract order ID and status update from the request
    const orderId = req.params.orderId;
    const { status } = req.body;

    // Update the order status and get the updated document in response
    const order = await Order.findByIdAndUpdate(
      orderId,
      { orderStatus: status },
      { new: true }
    );

    // If the order isn't found, return a not found error
    if (!order) {
      logger.warn(`Order with ID ${orderId} not found`);
      return res.status(404).json({ message: "Order not found" });
    }

    // Respond with the updated order details
    logger.info(`Order status for ID ${orderId} updated successfully`);
    return res.status(200).json(order);
  } catch (error) {
    // Log the error and respond with an internal server error status
    logger.error(
      `Error updating order status for ID ${orderId}: ${error.message}`
    );
    return res.status(500).json({ message: "Internal server error" });
  }
};

// Function to retrieve details of a specific order
export const getOrderDetails = async (req, res) => {
  try {
    // Extract order ID from the request parameters
    const orderId = req.params.orderId;

    // Fetch order details and populate the purchase requisition details
    const order = await Order.findById(orderId).populate("purchaseRequisition");

    // If the order isn't found, return a not found error
    if (!order) {
      logger.warn(`Order with ID ${orderId} not found`);
      return res.status(404).json({ message: "Order not found" });
    }

    // Log the successful retrieval for debugging
    logger.info(`Retrieved order details for ID: ${orderId}`);

    // Respond with the order details
    res.json(order);
  } catch (error) {
    // Log the error for debugging
    logger.error(
      `Error retrieving order details for ID ${orderId}: ${error.message}`
    );

    // Respond with an internal server error status
    return res.status(500).json({ message: "Internal server error" });
  }
};

// Function to get the status of a specific order
export const getOrderStatus = async (req, res) => {
  try {
    // Extract order ID from the request parameters
    const orderId = req.params.orderId;

    // Fetch only the status of the specified order
    const order = await Order.findById(orderId, "orderStatus");

    // If the order isn't found, return a not found error
    if (!order) {
      logger.warn(`Order with ID ${orderId} not found`);
      return res.status(404).json({ message: "Order not found" });
    }

    // Log the successful retrieval for debugging
    logger.info(`Retrieved order status for ID: ${orderId}`);

    // Respond with the order status
    res.json({ orderStatus: order.orderStatus });
  } catch (error) {
    // Log the error for debugging
    logger.error(
      `Error retrieving order status for ID ${orderId}: ${error.message}`
    );

    // Respond with an internal server error status
    return res.status(500).json({ message: "Internal server error" });
  }
};
