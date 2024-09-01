//SPDX-License-Identifier: MIT

import "./layerZeroInfra.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

pragma solidity 0.8.24;

contract astarL2ZkAstrEvm is infraLayerZero, ERC20, ERC20Burnable, ERC20Permit
{
    address public DESTINATION_CHAIN_ADDRESS;
    uint32 public DESTINATION_EID;
    
    constructor() infraLayerZero(0x6EDCE65403992e310A62460808c4b910D972f10f, msg.sender) ERC20("astarUsd", "astarUsd") ERC20Permit("astarUsd")
    {}
}