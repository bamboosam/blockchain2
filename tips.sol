// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "hardhat/console.sol";

contract tips{
    
    address owner;
    uint lastTransferTimeStamp = 0;
    uint oneYearLength = 300; // 365 days * 24 hours/day * 60 minutes/hour * 60 seconds/minute = 31,536,000 seconds
    Waitress[] waitress;

    constructor(){
        owner = msg.sender;
        lastTransferTimeStamp = block.timestamp;
        console.log(lastTransferTimeStamp);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    //1. put fund in smart contract
    function addtips() payable public {}

    //2. view balance
    function viewtips() public view returns(uint){
        return address(this).balance;
    }

    //3.1 add structure waitress
    struct Waitress{
        address payable walletAddress;
        string name;
        uint percent;
    }

    function keepAlive() public onlyOwner{
        lastTransferTimeStamp += oneYearLength;
        console.log(lastTransferTimeStamp);
    }

    //3.2 add waitress
    function addWaitress(address payable walletAddress,string memory name,uint percent) public onlyOwner{
        bool waitressExist = false;

        if(waitress.length >=1){
             for(uint i=0; i<waitress.length; i++){
               if(waitress[i].walletAddress == walletAddress){
                waitressExist = true;
               } 
            }

        }
        if(waitressExist==false){
            waitress.push(Waitress(walletAddress,name,percent));
        }
       
    }

    //4. remove user

    function removeWaitress(address walletAddress) public onlyOwner{
            if(waitress.length>=1){
                    
                    for(uint i=0; i<waitress.length; i++){
                        if(waitress[i].walletAddress == walletAddress){
                            // Shift elements to the left to fill the gap
                            for (uint j = i; j < waitress.length - 1; j++) {
                                waitress[j] = waitress[j + 1];
                            }
                            waitress.pop();
                            break; // Stop iterating once the item is found and removed
                        }
                    }
            }
        }

    //5. view waitress
    function viewWaitress() public view returns(Waitress[] memory) {
        return waitress;
    }

    //6. distribute tips
    function distributeBalance() public {
        console.log(lastTransferTimeStamp);
        console.log(block.timestamp);
        require(lastTransferTimeStamp < block.timestamp, "You are not able to Claim because not the time yet!! ");
        require(address(this).balance > 0, "Insufficient balance in the contract");
        if(waitress.length>=1){
                    uint totalamount = address(this).balance;
                    for(uint j=0; j<waitress.length; j++){
                        uint distributeAmount = totalamount * waitress[j].percent / 100;
                        _transferFunds(waitress[j].walletAddress, distributeAmount);
                    }
        }
    }


      // Internal function to actually transfer funds
    function _transferFunds(address payable recipient, uint amount) internal {
        recipient.transfer(amount);  
    }
}