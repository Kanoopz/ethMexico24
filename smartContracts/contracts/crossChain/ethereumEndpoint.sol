//SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { OApp, Origin, MessagingFee } from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { OptionsBuilder } from "@layerzerolabs/oapp-evm/contracts/oapp/libs/OptionsBuilder.sol";

interface mpUsd
{
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract ethereumEndpoint is OApp
{
    using OptionsBuilder for bytes;


    
    uint32 public ASTAR_ZKYOTO_EID = 40266;
    // address public MPUSD_TOKEN_ADDRESS = ;


    

    
    constructor() OApp(0x6EDCE65403992e310A62460808c4b910D972f10f, msg.sender) Ownable(msg.sender)
    {}

    function getPeerBytes32Address(address paramPeerAddress) public view returns(bytes32)
    {
        return bytes32(uint256(uint160(paramPeerAddress)));
    }

    function bridgeStablecoin(uint256 paramStablecoinQuantityToBridge) external payable 
    {
        // require(mpUsd(MPUSD_TOKEN_ADDRESS).balanceOf(msg.sender) >= paramStablecoinQuantityToBridge, "Not enought stablecoin balance.");
        // require(mpUsd(MPUSD_TOKEN_ADDRESS).allowance(msg.sender, address(this)) >= paramStablecoinQuantityToBridge, "Not enought allowance, please add more.");

        // bytes memory options = OptionsBuilder.newOptions().addExecutorLzComposeOption(0, 300000, 0);
        bytes memory options = OptionsBuilder.newOptions().addExecutorLzReceiveOption(50000, 0);

        bytes memory _payload = abi.encode(msg.sender, paramStablecoinQuantityToBridge);

        _lzSend(
            ASTAR_ZKYOTO_EID,
            _payload,
            options,
            // Fee in native gas and ZRO token.
            MessagingFee(msg.value, 0),
            // Refund address in case of failed source message.
            payable(msg.sender)
        );
    }

     function _lzReceive(
        Origin calldata _origin,
        bytes32 _guid,
        bytes calldata payload,
        address,  // Executor address as specified by the OApp.
        bytes calldata  // Any extra data or options to trigger on receipt.
    ) internal override {
        // Decode the payload to get the message
        // In this case, type is string, but depends on your encoding!
        // data = abi.decode(payload, (string));

        string memory str = "ESTO DE AQUI ES PARA QUEMARLO Y LIBERAR.";
    }
}