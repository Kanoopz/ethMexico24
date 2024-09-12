// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract wrappedBitcoin is ERC20, ERC20Burnable, Ownable, ERC20Permit {
    constructor()
        ERC20("wrappedBitcoin", "wBtc")
        Ownable(msg.sender)
        ERC20Permit("wrappedBitcoin")
    {}

    function mint(address to, uint256 amount) public 
    {
        _mint(to, amount);
    }

    function getAddress() public view returns(address)
    {
        return address(this);
    }
}