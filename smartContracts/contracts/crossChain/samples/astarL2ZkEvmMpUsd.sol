//SPDX-License-Identifier: MIT

import { OApp, Origin, MessagingFee } from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { OptionsBuilder } from "@layerzerolabs/oapp-evm/contracts/oapp/libs/OptionsBuilder.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

pragma solidity 0.8.24;

contract astarL2ZkEvmMpUsd is OApp, ERC20, ERC20Burnable, ERC20Permit
{
    using OptionsBuilder for bytes;



    uint32 public DESTINATION_EID = 40161;
    
    constructor() OApp(0x6EDCE65403992e310A62460808c4b910D972f10f, msg.sender) ERC20("zkMpUsd", "zkMpUsd") ERC20Permit("zkMpUsd") Ownable(msg.sender)
    {}

    function mint(address to, uint256 amount) public onlyOwner 
    {
        _mint(to, amount);
    }

    function _lzReceive(
        Origin calldata _origin,
        bytes32 _guid,
        bytes calldata payload,
        address,  // Executor address as specified by the OApp.
        bytes calldata  // Any extra data or options to trigger on receipt.
    ) internal override 
    {
        // Decode the payload to get the message
        // In this case, type is string, but depends on your encoding!
        // data = abi.decode(payload, (string));
        (address addressToMint, uint256 quantityToMint) = abi.decode(payload, (address, uint256));
        _mint(addressToMint, quantityToMint);
    }

    function getAddress() public view returns(address)
    {
        return address(this);
    }
}