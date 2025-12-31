// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract todolist{
    string[] list;
    function add(string memory work) public {
        list.push(work);
    }
    function show_list()public view returns(string[] memory){
        return list;
    }
    function completed(string memory work) public {
        for (uint i = 0; i < list.length; i++) {
            if (keccak256(bytes(list[i])) == keccak256(bytes(work))) {//sol does nt support string comparison so its compares their hashes
                list[i] = list[list.length - 1]; 
                list.pop(); 
                break; 
            }
        }
    }
}
    
