// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ContractPool.sol";


// Factory contract for creating Contract Pool contracts
contract ContractPoolFactory {

    // Accounts array
    ContractPoll[] public poolArray;

    //Event create contract
    event CreateAccount(address pool, address owner);

 
    function createPoolWallet( address payable _buyer, uint256 _securityDeposit, uint256 _sellerPreAgreementAmount, uint256 _buyerPreAgreementAmount, uint256 _endDate, uint256 _daysForWithdrawal) public returns(address) {
       ContractPoll pool = new ContractPoll(payable(msg.sender), payable(_buyer), _securityDeposit, _sellerPreAgreementAmount, _buyerPreAgreementAmount, _endDate, _daysForWithdrawal);    
       poolArray.push(pool);
       emit CreateAccount(address(pool), msg.sender);
       return address(pool);
    }

    // Function to make a deposit
    function poolDeposit(uint256 _poolindex) public {
        poolArray[_poolindex].deposit(msg.sender);
        }
 

    // Function to withdraw
    function poolWithdraw(uint256 _poolindex) public payable {
        poolArray[_poolindex].withdraw(msg.sender) ;
    }


    function getSeller(uint256 _poolindex) public view returns(address){
        return poolArray[_poolindex].returnSeller();
    }

    function getBuyer(uint256 _poolindex) public view returns(address){
        return poolArray[_poolindex].returnBuyer();
    }

    function getSellerBalance(uint256 _poolindex) public view returns(uint){
        return poolArray[_poolindex].sellerBalance();
    }

    function getBuyerBalance(uint256 _poolindex) public view returns(uint){
        return poolArray[_poolindex].buyerBalance();
    }

    
    function getSecurityDeposit(uint256 _poolindex) public view returns(uint){
        return poolArray[_poolindex].securityDeposit();
    }

    function getSellerPreAgreementAmount(uint256 _poolindex) public view returns(uint){
        return poolArray[_poolindex].sellerPreAgreementAmount();
    }

    function getBuyerPreAgreementAmount(uint256 _poolindex) public view returns(uint){
        return poolArray[_poolindex].buyerPreAgreementAmount();
    }

    function getEndDate(uint256 _poolindex) public view returns(uint){
        return poolArray[_poolindex].endDate();
    }

    function getDaysForWithdrawal(uint256 _poolindex) public view returns(uint){
        return poolArray[_poolindex].daysForWithdrawal();
    }


    // Return the Seller
    function seller(address _seller) public view returns (uint256[] memory) {
    uint256[] memory resultArray = new uint256[](poolArray.length);
    uint256 index = 0;
    for (uint256 i = 0; i < poolArray.length; i++) {
        if (poolArray[i].returnSeller() == _seller) {
            resultArray[index] = i;
            index++;
        }
    }
    return resultArray;
    }

    // Return the buyer
    function buyer(address _buyer) public view returns (uint256[] memory) {
    uint256[] memory resultArray = new uint256[](poolArray.length);
    uint256 index = 0;
    for (uint256 i = 0; i < poolArray.length; i++) {
        if (poolArray[i].returnBuyer() == _buyer) {
            resultArray[index] = i;
            index++;
        }
    }
    return resultArray;
    }
 
}

