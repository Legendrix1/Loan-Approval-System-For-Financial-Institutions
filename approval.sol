 	
// SPDX-License-Identifier: MIT
 /**
   * @title ContractName
   * @dev ContractDescription
   * @custom:dev-run-script file_path
   */
  contract ContractName {}
  
  pragma solidity ^0.8.0;

contract LoanApprovalSystem {

  // Define variables
  address public admin;
  mapping(address => bool) public registeredUsers;
  mapping(address => uint) public userBalance;
  uint public loanAmount;
  uint public loanDuration;
  uint public interestRate;

  // Define events
  event UserRegistered(address user);
  event LoanRequested(address user, uint amount, uint duration);
  event LoanApproved(address user, uint amount, uint duration);

  // Constructor function
  constructor(uint _loanAmount, uint _loanDuration, uint _interestRate) {
    admin = msg.sender;
    loanAmount = _loanAmount;
    loanDuration = _loanDuration;
    interestRate = _interestRate;
  }

  // Function to register new users
  function registerUser() public {
    registeredUsers[msg.sender] = true;
    userBalance[msg.sender] = 0;
    emit UserRegistered(msg.sender);
  }

  // Function to request a loan
  function requestLoan(uint _loanAmount, uint _loanDuration) public {
    require(registeredUsers[msg.sender], "User must be registered");
    require(_loanAmount > 0, "Loan amount must be greater than zero");
    require(_loanAmount <= userBalance[msg.sender], "Insufficient balance for loan request");
    loanAmount = _loanAmount;
    loanDuration = _loanDuration;
    emit LoanRequested(msg.sender, _loanAmount, _loanDuration);
  }

  // Function for admin to approve loan requests
  function approveLoan(address _user) public {
    require(msg.sender == admin, "Only admin can approve loans");
    require(registeredUsers[_user], "User must be registered");
    require(loanAmount > 0, "Loan request must be made first");
    require(userBalance[_user] >= loanAmount, "Insufficient balance for loan approval");
    userBalance[_user] -= loanAmount;
    emit LoanApproved(_user, loanAmount, loanDuration);
  }

  // Function to add funds to user balance
  function addFunds() public payable {
    userBalance[msg.sender] += msg.value;
  }

  // Function to get user balance
  function getBalance() public view returns (uint) {
    return userBalance[msg.sender];
  }

}
