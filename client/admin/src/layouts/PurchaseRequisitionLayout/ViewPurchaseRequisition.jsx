import React from "react";
import { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import { styled } from "@mui/material/styles";
import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import { TextField } from "@mui/material";
import TableContainer from "@mui/material/TableContainer";
import TableHead from "@mui/material/TableHead";
import TableRow from "@mui/material/TableRow";
import Paper from "@mui/material/Paper";
import CheckIcon from "@mui/icons-material/Check";
import CloseIcon from "@mui/icons-material/Close";
import axios from "axios";
import { Modal } from "antd";

const ViewPurchaseRequisition = () => {
  const [visible, setVisible] = useState(false);
  const [requisitions, setAllRequisition] = useState([]);
  const [allRequisitions, setAllRequisitions] = useState([]);
  const [reason, setReason] = useState();
  const [selectedId, setSelectedId] = useState();
  const [errors, setErrors] = useState("");

  useEffect(() => {
    function getAllRequisition() {
      axios
        .get("http://localhost:8080/purchase-requisition/get-all-pr")
        .then((res) => {
          const filteredRequisition = res.data.filter(
            (requisition) => parseInt(requisition.totalAmount, 10) < 100000
          );
          setAllRequisition(filteredRequisition);
          setAllRequisitions(res.data);
        })
        .catch((err) => {
          console.error("Error : " + err.message);
        });
    }

    getAllRequisition();
  }, []);

  const StyledTableCell = styled(TableCell)(({ theme }) => ({
    [`&.${tableCellClasses.head}`]: {
      backgroundColor: "#facc15",
      color: theme.palette.common.black,
    },
    [`&.${tableCellClasses.body}`]: {
      fontSize: 14,
    },
  }));

  const StyledTableRow = styled(TableRow)(({ theme }) => ({
    "&:nth-of-type(odd)": {
      backgroundColor: theme.palette.action.hover,
    },
    // hide last border
    "&:last-child td, &:last-child th": {
      border: 0,
    },
  }));

  function approveRequisition(objId) {
    axios
      .put("http://localhost:8080/purchase-requisition/update-items", {
        _id: objId,
        approvalStatus: "Approved",
        reason: "",
      })
      .then((res) => {
        if (res.data != null)
          window.location.replace(
            "http://localhost:3000/purchaseRequisition/view-requisition"
          );
      })
      .catch((err) => {
        console.error("Error : " + err.message);
      });
  }

  function rejectRequisition(e) {
    e.preventDefault;

    if (!reason) {
      setErrors("Please provide a reason");
      return;
    }

    axios
      .put("http://localhost:8080/purchase-requisition/update-items", {
        _id: selectedId,
        approvalStatus: "Declined",
        reason: reason,
      })
      .then((res) => {
        if (res.data != null)
          window.location.replace(
            "http://localhost:3000/purchaseRequisition/view-requisition"
          );
      })
      .catch((err) => {
        console.error("Error : " + err.message);
      });
  }

  return (
    <>
      <TableContainer component={Paper} style={{ marginTop: "20px" }}>
        <Table>
          <TableHead>
            <TableRow>
              <StyledTableCell>Requisition ID</StyledTableCell>
              <StyledTableCell align="right">Item</StyledTableCell>
              <StyledTableCell align="right">Quantity</StyledTableCell>
              <StyledTableCell align="right">Total Amount</StyledTableCell>
              <StyledTableCell align="right">Status</StyledTableCell>
              <StyledTableCell align="right"></StyledTableCell>
              <StyledTableCell align="right"></StyledTableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {requisitions
              .filter((key) => {
                const status = (key.approvalStatus || "").toLowerCase();
                return status.includes("pending");
              })
              .map((requisition) => (
                <StyledTableRow>
                  <StyledTableCell component="th" scope="row">
                    {requisition._id}
                  </StyledTableCell>
                  <StyledTableCell align="right">
                    {requisition.item}
                  </StyledTableCell>
                  <StyledTableCell align="right">
                    {requisition.quantity}
                  </StyledTableCell>
                  <StyledTableCell align="right">
                    {requisition.totalAmount}
                  </StyledTableCell>
                  <StyledTableCell align="right">
                    {requisition.approvalStatus}
                  </StyledTableCell>
                  <StyledTableCell align="right">
                    <button
                      className="g-transparent text-yellow-600 border-yellow-400 hover:bg-yellow-500 hover:text-white font-semibold  py-2 px-4 border border-blue-500 hover:border-transparent rounded"
                      onClick={() => {
                        approveRequisition(requisition._id);
                      }}
                    >
                      <CheckIcon />
                    </button>
                  </StyledTableCell>
                  <StyledTableCell align="right">
                    <button
                      className="bg-transparent text-red-600 border-red-600 hover:bg-red-600 hover:text-white font-semibold  py-2 px-4 border border-blue-500 hover:border-transparent rounded"
                      onClick={() => {
                        setVisible(true);
                        setSelectedId(requisition._id);
                      }}
                    >
                      <CloseIcon />
                    </button>
                  </StyledTableCell>
                </StyledTableRow>
              ))}
          </TableBody>
        </Table>
      </TableContainer>

      <TableContainer component={Paper} style={{ marginTop: "20px" }}>
        <Table>
          <TableHead>
            <TableRow>
              <StyledTableCell>Requisition ID</StyledTableCell>
              <StyledTableCell align="right">Item</StyledTableCell>
              <StyledTableCell align="right">Quantity</StyledTableCell>
              <StyledTableCell align="right">Total Amount</StyledTableCell>
              <StyledTableCell align="right">Status</StyledTableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {allRequisitions.map((requisition) => (
              <StyledTableRow>
                <StyledTableCell component="th" scope="row">
                  {requisition._id}
                </StyledTableCell>
                <StyledTableCell align="right">
                  {requisition.item}
                </StyledTableCell>
                <StyledTableCell align="right">
                  {requisition.quantity}
                </StyledTableCell>
                <StyledTableCell align="right">
                  {requisition.totalAmount}
                </StyledTableCell>
                <StyledTableCell align="right">
                  {requisition.approvalStatus}
                </StyledTableCell>
              </StyledTableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      <Modal onCancel={() => setVisible(false)} footer={null} open={visible}>
        <div className="flex justify-center p-10">
          <div className="col-span-2 flex flex-col items-center pt-5">
            <TextField
              label="Reason"
              name="reason"
              onChange={(e) => setReason(e.target.value)}
              variant="outlined"
              style={{ width: "500px" }}
            />
            <button
              type="submit"
              onClick={rejectRequisition}
              className="g-transparent mt-5 text-yellow-600 border-yellow-400 hover:bg-yellow-500 hover:text-white font-semibold  py-2 px-4 border border-blue-500 hover:border-transparent rounded"
            >
              Reject Requisition
            </button>

            <div class="col-span-2 flex justify-center pt-5">
              {errors ? (
                <div className="w-full justify-center text-center px-[20px] py-[10px] border-2 border-red-700 bg-red-100 text-red-700 rounded text-xs">
                  {errors ? errors : ""}
                </div>
              ) : (
                <></>
              )}
            </div>
          </div>
        </div>
      </Modal>
    </>
  );
};

export default ViewPurchaseRequisition;
