import React from "react";
import {
  render,
  screen,
  waitFor,
  fireEvent,
  act,
} from "@testing-library/react";

import "@testing-library/jest-dom";
import axios from "axios";
import ViewPurchaseRequisition from "./ViewPurchaseRequisition";

// Mocking the axios module
jest.mock("axios");

describe("ViewPurchaseRequisition Component", () => {
  beforeEach(() => {
    // Setting up a fake response for the API call
    axios.get.mockResolvedValue({ data: [] });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("renders ViewPurchaseRequisition component without crashing", async () => {
    await act(async () => {
      render(<ViewPurchaseRequisition />);
    });
  });

  it("makes an API call on render to fetch requisitions", async () => {
    await act(async () => {
      render(<ViewPurchaseRequisition />);
    });

    await waitFor(() => {
      expect(axios.get).toHaveBeenCalledWith(
        "http://localhost:8080/purchase-requisition/get-all-pr"
      );
    });
  });

  it("displays modal with reason input and rejection button when reject button is clicked", async () => {
    await act(async () => {
      render(<ViewPurchaseRequisition />);
    });

    // For demonstration purposes, assume you have at least one requisition data for testing
    const rejectBtn = screen.getByText((content, node) => {
      const hasText = (node) => node.textContent === "Reject Requisition";
      const nodeHasText = hasText(node);
      const childrenDontHaveText = Array.from(node.children).every(
        (child) => !hasText(child)
      );

      return nodeHasText && childrenDontHaveText;
    });

    fireEvent.click(rejectBtn);

    expect(screen.getByLabelText("Reason")).toBeInTheDocument();
    await waitFor(() =>
      expect(screen.getByText("Reject Requisition")).toBeInTheDocument()
    );
  });
});
