// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */

contract LoanPlatform {
    // Define a struct to represent a borrower
    struct Borrower {
        string name;
        string email;
        string password;
        bool kycVerified;
    }

    // Define a mapping to store the borrowers
    mapping(address => Borrower) public borrowers;

    // Define an event to emit when a borrower signs up
    event Signup(address indexed borrower, string name, string email);

    // Define a function to allow borrowers to sign up
    function signup(string memory name, string memory email, string memory password) public {
        // Check if the borrower already exists
        require(bytes(borrowers[msg.sender].email).length == 0, "Borrower already exists");
        // Create a new borrower
        Borrower memory borrower = Borrower(name, email, password, false);
        borrowers[msg.sender] = borrower;

        // Emit the Signup event
        emit Signup(msg.sender, name, email);
    }

    // Define a function for the bank admin to verify the KYC of a borrower
    function verifyKyc(address borrowerAddress) public {
        // Check if the borrower exists
        require(bytes(borrowers[borrowerAddress].email).length > 0, "Borrower does not exist");

        // Verify the KYC of the borrower
        borrowers[borrowerAddress].kycVerified = true;
    }
}
