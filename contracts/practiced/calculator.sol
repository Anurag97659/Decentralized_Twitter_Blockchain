// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract calculator{
    uint256 result=0;
    
    function add(uint256 num) public{
        require(num>=1, "Number must be non-negative");
        result +=num;
    }
     function sub(uint256 num) public{
        result -=num;
    }
     function mul(uint256 num) public{
        result *=num;
    }
     function div(uint256 num) public{
        result /=num;
    }
    function show() view public returns (uint256){
        return result;
    }
    function reset() public {
        result =0;
    }
}