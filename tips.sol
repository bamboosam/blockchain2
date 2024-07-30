// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract tips{

    address owner;
    constructor(){
        owner = msg.sender;
    }

 function addtips() payable public {

    }

     function viewtips() public view returns(uint){
        return address(this).balance;
    }
}