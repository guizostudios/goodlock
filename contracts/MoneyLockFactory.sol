// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MoneyLock.sol";


// Factory contract for creating Money Lock contracts
contract MoneyLockFactory {

    // Accounts array
    MoneyLock[] public moneyArray;

    //Event create contract
    event CreateAccount(address money, address owner);

 
    function createMoneyLockWallet( address _taker, uint256 _securityDeposit, uint256 _endDate, uint256 _daysForWithdrawal) public returns(address) {
       MoneyLock money = new MoneyLock(payable(msg.sender), payable(_taker), _securityDeposit, _endDate, _daysForWithdrawal);    
       moneyArray.push(money);
       emit CreateAccount(address(money), msg.sender);
       return address(money);
    }

    // Function to make a deposit
    function moneyDeposit(uint256 _moneyindex) public {
        moneyArray[_moneyindex].deposit(msg.sender);
        }
 

    // Function to withdraw
    function moneyWithdraw(uint256 _moneyindex) public payable {
        moneyArray[_moneyindex].withdraw(msg.sender) ;
    }


    function getOwner(uint256 _moneyindex) public view returns(address){
        return moneyArray[_moneyindex].returnOwner();
    }

    function getTaker(uint256 _moneyindex) public view returns(address){
        return moneyArray[_moneyindex].returnTaker();
    }

    function getTokerBalance(uint256 _moneyindex) public view returns(uint){
        return moneyArray[_moneyindex].takerBalance();
    }


    function getSecurityDeposit(uint256 _moneyindex) public view returns(uint){
        return moneyArray[_moneyindex].securityDeposit();
    }


    function getEndDate(uint256 _moneyindex) public view returns(uint){
        return moneyArray[_moneyindex].endDate();
    }

    function getDaysForWithdrawal(uint256 _moneyindex) public view returns(uint){
        return moneyArray[_moneyindex].daysForWithdrawal();
    }


    // Return the owner
    function owner(address _owner) public view returns (uint256[] memory) {
    uint256[] memory resultArray = new uint256[](moneyArray.length);
    uint256 index = 0;
    for (uint256 i = 0; i < moneyArray.length; i++) {
        if (moneyArray[i].returnOwner() == _owner) {
            resultArray[index] = i;
            index++;
        }
    }
    return resultArray;
    }

    // Return the taker
    function taker(address _taker) public view returns (uint256[] memory) {
    uint256[] memory resultArray = new uint256[](moneyArray.length);
    uint256 index = 0;
    for (uint256 i = 0; i < moneyArray.length; i++) {
        if (moneyArray[i].returnTaker() == _taker) {
            resultArray[index] = i;
            index++;
        }
    }
    return resultArray;
    }
 
}

