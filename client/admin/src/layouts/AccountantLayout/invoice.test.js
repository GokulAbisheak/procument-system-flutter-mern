import React from "react";
import { render, screen, waitFor, act } from "@testing-library/react";
import "@testing-library/jest-dom";
import axios from "axios";
import ViewInvoices from "./AllInvoices";

// Mocking the axios module
jest.mock("axios");

describe("viewAllInvoices Component", () => {
  beforeEach(() => {
    // setting up a fake response for the API call
    axios.get.mockResolvedValue({ data: [] });

    // Mocking localStorage
    const mockLocalStorageValue = {
      getItem: jest.fn(
        (key) => key === "AccountantInfo" && JSON.stringify({ _id: "12345" })
      ),
      setItem: jest.fn(),
      clear: jest.fn(),
    };
    global.localStorage = mockLocalStorageValue;
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("renders viewAllInvoices component without crashing", async () => {
    await act(async () => {
      render(<ViewInvoices />);
    });
  });

  it("has the correct table headers", async () => {
    await act(async () => {
      render(<ViewInvoices />);
    });

    expect(screen.getByText("Invoice ID")).toBeInTheDocument();
    expect(screen.getByText("Order Id")).toBeInTheDocument();
    expect(screen.getByText("Item")).toBeInTheDocument();
    expect(screen.getByText("Quantity")).toBeInTheDocument();
    expect(screen.getByText("Price per unit")).toBeInTheDocument();
    expect(screen.getByText("Total Amount")).toBeInTheDocument();
    expect(screen.getByText("Order status")).toBeInTheDocument();
  });
});
