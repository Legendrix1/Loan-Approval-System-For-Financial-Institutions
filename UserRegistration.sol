// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */

contract UserRegistrationSystem {
    
    struct User {
    address userAddress;
    uint accountNumber;
    uint bvn;
    uint nin;
    uint email;
    }

    
    mapping(address => User) public users;
    mapping(uint => bool) public usedAccountNumbers;
    mapping(uint => bool) public usedBVNs;
    mapping(uint => bool) public usedNINs;
    
    event UserRegistered(address indexed userAddress, uint accountNumber, uint bvn, uint nin);
    
    function register( uint _accountNumber, uint _bvn, uint _email, uint _nin) public {
        require(!usedAccountNumbers[_accountNumber], "Account number already registered");
        require(!usedBVNs[_bvn], "BVN already registered");
        require(!usedNINs[_nin], "NIN already registered");
        
        usedAccountNumbers[_accountNumber] = true;
        usedBVNs[_bvn] = true;
        usedNINs[_nin] = true;
        
        User memory newUser = User(msg.sender, _email, _accountNumber, _bvn, _nin);
        users[msg.sender] = newUser;
        
        emit UserRegistered(msg.sender, _accountNumber, _bvn, _nin);
    }
    
    function getUser() public view returns (address, uint, uint, uint) {
        User storage currentUser = users[msg.sender];
        return (currentUser.userAddress, currentUser.accountNumber, currentUser.bvn, currentUser.nin);
    }
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    receive() external payable {
        // Handle incoming Ether
    }
    
    fallback() external payable {
        // Handle unexpected incoming Ether
    }
}

