// SPDX-License-Identifier: LGPL-3.0-only

// Solidity version
pragma solidity 0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SmartInvoice is Ownable {
    // State Variables
    struct Invoice {
        uint256 id;
        address client;
        string description;
        uint256 amount;
        bool paid;
    }

    
    uint256 public invoiceCount;
    mapping(uint256 => Invoice) private invoices;

    // Modifiers
    
    // Events
    
    event CreateInvoice(address indexed client, string description, uint256 amount);

    event PayInvoice(uint256 indexed idClient);

    // Constructor
    constructor() Ownable(msg.sender) {
       
    }

    // External Functions

    function createInvoice(
        address client_,
        string memory description_,
        uint256 amount_
    ) public onlyOwner {
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

        emit CreateInvoice(client_, description_, amount_);
    }

    function payInvoice(uint256 id_) public payable {
        require(id_ < invoiceCount, "Invoice does not exist");
        require(invoices[id_].paid == false, "Invoice already paid");

        invoices[id_].paid = true;

        emit PayInvoice(id_);
    }

    function getInvoice(uint256 id_) public view returns (Invoice memory) {
        require(id_ < invoiceCount, "Invoice does not exist");
        return invoices[id_];
    }
}
