// SPDX-License-Identifier: LGPL-3.0-only

pragma solidity 0.8.24;

contract SmartInvoice {
    // State Variables
    struct Invoice {
        uint256 id;
        address client;
        string description;
        uint256 amount;
        bool paid;
    }

    address public owner;
    uint256 public invoiceCount;
    mapping(uint256 => Invoice) private invoices;

    // Constructor
    constructor() {
        owner = msg.sender;
    }

    // External Functions

    function createInvoice(
        address client_,
        string memory description_,
        uint256 amount_
    ) public {
        require(client_ != address(0), "Invalid client address");
        require(amount_ > 0, "Amount must be greater than 0");

        Invoice memory newInvoice = Invoice(
            invoiceCount,
            client_,
            description_,
            amount_,
            false
        );
        invoices[invoiceCount] = newInvoice;
        invoiceCount++;
    }

    function payInvoice(uint256 id_) public payable {
        require(id_ < invoiceCount, "Invoice does not exist");
        require(invoices[id_].paid == false, "Invoice already paid");
        require(msg.value == invoices[id_].amount, "Incorrect payment amount");

        invoices[id_].paid = true;
    }

    function getInvoice(uint256 id_) public view returns (Invoice memory) {
        require(id_ < invoiceCount, "Invoice does not exist");
        return invoices[id_];
    }
}
