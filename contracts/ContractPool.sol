// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

//contract ContractPoll
contract ContractPoll is ReentrancyGuard {
    // Variables to store the addresses of the seller and buyer
    address payable seller;
    address payable buyer;
    address payable feeAddress;

    // Variable to store the balance of the contract
    uint256 public contractBalance;
    uint256 public sellerBalance;
    uint256 public buyerBalance;

    // Variables to store the security deposit, pre-agreement amounts, end date, and days for withdrawal
    uint256 public securityDeposit;
    uint256 public sellerPreAgreementAmount;
    uint256 public buyerPreAgreementAmount;
    uint256 public endDate;
    uint256 public daysForWithdrawal;

    //Application fee
    uint transferFee;
    uint fee;

    // Event to emit when funds are deposited
    event FundsDeposited(address indexed depositor, uint256 amount);

    // Deposit event
    event Deposit(address indexed contractAddress, address indexed from, uint amount);

    using SafeMath for uint256;

    // Constructor to initialize the contract with the addresses of the seller and buyer, the security deposit, pre-agreement amounts, end date, and days for withdrawal
    constructor(address payable _seller, address payable _buyer, uint256 _securityDeposit, uint256 _sellerPreAgreementAmount, uint256 _buyerPreAgreementAmount, uint256 _endDate, uint256 _daysForWithdrawal)  {
        seller = _seller;
        buyer = _buyer;
        securityDeposit = _securityDeposit;
        sellerPreAgreementAmount = _sellerPreAgreementAmount;
        buyerPreAgreementAmount = _buyerPreAgreementAmount;
        endDate = _endDate;
        daysForWithdrawal = _daysForWithdrawal;
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
    function deposit(address _user) external payable {
        require(_user == seller || _user == buyer, "Only the seller or buyer can deposit funds");
        if (_user == seller) {
            sellerBalance += msg.value;
        } else {
            buyerBalance += msg.value;
        }
        contractBalance += msg.value;
        emit FundsDeposited(_user, msg.value);
    }

   

    // Function for the buyer or seller to withdraw the security deposit

    function withdraw(address _user) external payable nonReentrant {
        require (address(this).balance != 0, "Contract don't have funds");
        require (block.timestamp < endDate, "Time is not over yet");
        fee = address(this).balance.mul(transferFee).div(100);
          // If the end date has passed but don't have passed enddate + daystowithdraw and the seller have fulfilled his or her obligations, the seller can withdraw the funds
        if (sellerBalance > sellerPreAgreementAmount && block.timestamp > endDate && block.timestamp < endDate + (daysForWithdrawal * 1 days)) {
            require (seller == _user, "You are not the seller");
            seller.transfer(address(this).balance.sub(fee));
            feeAddress.transfer(fee);
        }        
        // The buyer didn't withdraw the balance. So he or she backed out of the deal
        else if  (buyerBalance > securityDeposit && block.timestamp > endDate + (daysForWithdrawal * 1 days)) {
            require (buyer == _user, "You are not the buyer");
            buyer.transfer(address(this).balance.sub(fee));
            feeAddress.transfer(fee);
        }
        // The time expired but neither of the two deposited the pre-agreement
        else if (address(this).balance != 0 && sellerBalance < sellerPreAgreementAmount && buyerBalance < buyerPreAgreementAmount && block.timestamp > endDate + (daysForWithdrawal * 1 days)){
                require(_user == buyer || _user == seller, "Just buyer or seller can withdraw");
                if (_user == buyer && buyerBalance != 0){
                    fee = buyerBalance.mul(transferFee).div(100);
                    buyer.transfer(buyerBalance.sub(fee));
                    feeAddress.transfer(fee);
                    buyerBalance = 0;
                }
                else if(_user == seller && sellerBalance != 0) {
                    fee = sellerBalance.mul(transferFee).div(100);
                    seller.transfer(sellerBalance.sub(fee));
                    feeAddress.transfer(fee);
                    sellerBalance = 0;
                }
        }
  
    }

 
    function returnSeller() public view returns(address){
        return seller;
    }

    function returnBuyer() public view returns(address){
        return buyer;
    }

    function returnSellerBalance() public view returns(uint){
        return sellerBalance;
    }

    function returnBuyerBalance() public view returns(uint){
        return buyerBalance;
    }

    
    function returnSecurityDeposit() public view returns(uint){
        return securityDeposit;
    }

    function returnSellerPreAgreementAmount() public view returns(uint){
        return sellerPreAgreementAmount;
    }

    function returnBuyerPreAgreementAmount() public view returns(uint){
        return buyerPreAgreementAmount;
    }

    function returnEndDate() public view returns(uint){
        return endDate;
    }

    function returnDaysForWithdrawal() public view returns(uint){
        return daysForWithdrawal;
    }

}
