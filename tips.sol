// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract tips{

    address owner;
    Waitress[] waitress;

    constructor(){
        owner = msg.sender;
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

    //3.2 add waitress
    function addWaitress(address payable walletAddress,string memory name,uint percent) public{
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

    function removePurpose(address walletAddress) public{
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
        require(address(this).balance > 0, "Insufficient balance in the contract");
        if(waitress.length>=1){
                    
                    for(uint j=0; j<waitress.length; j++){
                        uint distributeAmount = address(this).balance * waitress[j].percent / 100;
                        _transferFunds(waitress[j].walletAddress, distributeAmount);
                    }
        }
    }


      // Internal function to actually transfer funds
    function _transferFunds(address payable recipient, uint amount) internal {
        recipient.transfer(amount);  
    }
}