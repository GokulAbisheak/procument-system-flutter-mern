// PurchaseRequisitionController.mjs

import PurchaseRequisition from '../models/PurchaseRequisition.mjs';

export const addItems = async (req, res) => {
    const { empId, item, quantity, pricePerUnit, totalAmount, approvalStatus } = req.body;

    try {
        const purchaseRequisition = await PurchaseRequisition.create({
            empId,
            item,
            quantity,
            pricePerUnit,
            totalAmount,
            approvalStatus,
            reason: '',
            dateTime: new Date()
        });
        console.log({ status: 'Success', purchaseRequisition });
        res.json(purchaseRequisition);
    } catch (err) {
        console.log({ status: 'Error', err });
    }
}

export const getAllPurchaseRequisitions = async (req, res) => {
    try {
        const purchaseRequisitions = await PurchaseRequisition.find();
        res.json(purchaseRequisitions);
    } catch (err) {
        console.log({ status: 'Error', err });
    }
}

export const getPurchaseRequisitionById = async (req, res) => {
    const { _id } = req.params;

    try {
        const purchaseRequisition = await PurchaseRequisition.findById(_id);
        res.json(purchaseRequisition);
    } catch (err) {
        console.log({ status: 'Error', err });
    }
}

export const updateItems = async (req, res) => {
    const { _id, approvalStatus, reason } = req.body;
    
    try {
        const purchaseRequisition = await PurchaseRequisition.findById(_id);
        if (!purchaseRequisition) {
            res.json({ status: 'No user' });
        } else {
            purchaseRequisition.reason = reason;
            purchaseRequisition.approvalStatus = approvalStatus;
            purchaseRequisition.lastModifiedDateTime = new Date();

            const updatedPurchaseRequisition = await purchaseRequisition.save();
            res.json(updatedPurchaseRequisition);
        }
    } catch (err) {
        console.log({ status: 'Error', err });
    }
}

export const getPurchaseRequisitionByEmpId = async (req, res) => {
    const { empId } = req.params;

    try {
        const purchaseRequisitions = await PurchaseRequisition.find({ empId: empId });
        if (!purchaseRequisitions || purchaseRequisitions.length === 0) {
            return res.json({ status: "No PurchaseRequisition found" });
        } else {
            return res.json(purchaseRequisitions);
        }
    } catch (err) {
        console.log({ status: "Error", err });
        return res.json({ status: "Error", err });
    }
};
