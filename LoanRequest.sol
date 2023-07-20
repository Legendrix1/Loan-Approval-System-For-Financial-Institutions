// SPDX-License-Identifier: MIT

 pragma solidity ^0.8.0;

 /**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */

contract LoanRequest {
    
    // Define variables
    struct Loan {
        address borrower;
        uint256 amount;
        bool approved;
    }
    
    address public admin;
    mapping(address => Loan) public loans;
    
    // Define events
    event LoanRequested(address indexed borrower, uint256 amount);
    event LoanApproved(address indexed borrower, uint256 amount);
    event TransactionHashed(bytes32 indexed transactionHash);
    
    // Constructor function
    constructor() {
        admin = msg.sender;
    }
    
    // Function to request a loan
    function requestedLoan(uint256 _amount) public {
        require(msg.sender != admin, "Admin cannot request a loan");
        loans[msg.sender] = Loan(msg.sender, _amount, false);
        emit LoanRequested(msg.sender, _amount);
        bytes32 transactionHash = keccak256(abi.encodePacked(msg.sender, _amount, block.timestamp));
        emit TransactionHashed(transactionHash);
    }
    
    // Function to approve a loan
    function approveLoan(address _borrower) public {
        require(msg.sender == admin, "Only admin can approve loans");
        loans[_borrower].approved = true;
        emit LoanApproved(_borrower, loans[_borrower].amount);
        bytes32 transactionHash = keccak256(abi.encodePacked(_borrower, loans[_borrower].amount, block.timestamp));
        emit TransactionHashed(transactionHash);
    }
    
    // Function to check if a loan is approved
    function isLoanApproved(address _borrower) public view returns (bool) {
        return loans[_borrower].approved;
    }
    
    // Function to set a new admin
    function setAdmin(address _newAdmin) public {
        require(msg.sender == admin, "Only current admin can set a new admin");
        admin = _newAdmin;
    }
}

