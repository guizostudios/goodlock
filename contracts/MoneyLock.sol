// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

//Contract Moneylock
contract MoneyLock is ReentrancyGuard {
    // Address of the party that holds the security deposit
    address payable owner;
    // Address of the other party
    address payable taker;
    // fee address
    address payable feeAddress;
    // Security deposit amount
    uint256 public securityDeposit;
    // End date of the agreement
    uint256 public endDate;
    // Days for the other party to withdraw the money
    uint256 public daysForWithdrawal;
    //Taker balance
    uint256 public takerBalance;
    //Application fee
    uint transferFee;
    uint fee;

    // Deposit event
    event Deposit(address indexed contractAddress, address indexed from, uint amount);

    // Event to emit when funds are deposited
    event FundsDeposited(address indexed takerDeposit, uint256 amount);

    using SafeMath for uint256;

    // Constructor to initialize the contract
    constructor(address payable _owner, address payable _taker, uint256 _securityDeposit, uint256 _endDate, uint256 _daysForWithdrawal) {
        // Store the address of the owner
        owner = _owner;
        // Store the address of the taker
        taker = _taker;
        // Store the security deposit amount
        securityDeposit = _securityDeposit;
        // Store the end date of the agreement
        endDate = _endDate;
        // Store the days for the other party to withdraw the money
        daysForWithdrawal = _daysForWithdrawal;
        //Fee
        transferFee = 1;
        feeAddress = payable(0x4AA6E55f232A25CE720996a29761806cE34B75Fe);
    }

      //Fallback function
    fallback () external payable {
        emit Deposit(address(this), msg.sender, msg.value);
    } 

    //Receive function
    receive () external payable {
        emit Deposit(address(this), msg.sender, msg.value);
    }


    // Function to deposit funds to the contract
    function deposit(address _taker) external payable {
        require(_taker == taker, "Only the taker can deposit funds");
        takerBalance += msg.value;
        emit FundsDeposited(_taker, msg.value);
    }

    // Function for the buyer or seller to withdraw the security deposit

    function withdraw(address _user) external payable nonReentrant {
        require (address(this).balance != 0, "Contract don't have funds");
        require (block.timestamp < endDate, "Time is not over yet");
        fee = address(this).balance.mul(transferFee).div(100);
          // If the end date has passed but don't have passed enddate + daystowithdraw, the owner can withdraw the funds
        if (block.timestamp > endDate && block.timestamp < endDate + (daysForWithdrawal * 1 days)) {
            require (owner == _user, "You are not the owner");
            owner.transfer(address(this).balance.sub(fee));
            feeAddress.transfer(fee);
        }        
        // The owner didn't withdraw the balance. So the taker can withdraw it
        else if  (block.timestamp > endDate + (daysForWithdrawal * 1 days)) {
            require (taker == _user, "You are not the taker");
            taker.transfer(address(this).balance.sub(fee));
            feeAddress.transfer(fee);
        }
    }

 
    function returnOwner() public view returns(address){
        return owner;
    }

    function returnTaker() public view returns(address){
        return taker;
    }

    function returnTakerBalance() public view returns(uint){
        return takerBalance;
    }

    
    function returnSecurityDeposit() public view returns(uint){
        return securityDeposit;
    }

    function returnEndDate() public view returns(uint){
        return endDate;
    }

    function returnDaysForWithdrawal() public view returns(uint){
        return daysForWithdrawal;
    }

}
