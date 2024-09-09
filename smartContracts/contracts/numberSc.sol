//SPDX-License-Identifier MIT

pragma solidity 0.8.24;

contract numberSc
{
    address public lastCaller;
    uint public number;

    function setNumber(uint newNumber) public
    {
        number = newNumber;
        lastCaller = msg.sender;
    }
}