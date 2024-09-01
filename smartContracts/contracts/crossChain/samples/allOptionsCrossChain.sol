//SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { OApp, Origin, MessagingFee } from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { OptionsBuilder } from "@layerzerolabs/oapp-evm/contracts/oapp/libs/OptionsBuilder.sol";

interface astarUsd
{
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract astarEvmEndpoint is OApp
{
    using OptionsBuilder for bytes;


    
    uint32 public ASTAR_ZKYOTO_EID = 40266;
    // address public ASTARUSD_TOKEN_ADDRESS = ;


    

    
    constructor() OApp(0x6EDCE65403992e310A62460808c4b910D972f10f, msg.sender) Ownable(msg.sender)
    {}

    function getPeerBytes32Address(address paramPeerAddress) public view returns(bytes32)
    {
        return bytes32(uint256(uint160(paramPeerAddress)));
    }

    // function bridgeStablecoin(uint256 paramStablecoinQuantityToBridge) external payable 
    // {
    //     // require(astarUsd(ASTARUSD_TOKEN_ADDRESS).balanceOf(msg.sender) >= paramStablecoinQuantityToBridge, "Not enought stablecoin balance.");
    //     // require(astarUsd(ASTARUSD_TOKEN_ADDRESS).allowance(msg.sender, address(this)) >= paramStablecoinQuantityToBridge, "Not enought allowance, please add more.");

    //     // bytes memory options = OptionsBuilder.newOptions().addExecutorLzComposeOption(0, 300000, 0);
    //     bytes memory options = OptionsBuilder.newOptions().addExecutorLzReceiveOption(50000, 0);

    //     bytes memory _payload = abi.encode(msg.sender, paramStablecoinQuantityToBridge);

    //     _lzSend(
    //         ASTAR_ZKYOTO_EID,
    //         _payload,
    //         options,
    //         // Fee in native gas and ZRO token.
    //         MessagingFee(msg.value, 0),
    //         // Refund address in case of failed source message.
    //         payable(msg.sender)
    //     );
    // }



    function bridgeStablecoinReceiveDeafult(uint256 paramStablecoinQuantityToBridge) external payable 
    {
        // require(astarUsd(ASTARUSD_TOKEN_ADDRESS).balanceOf(msg.sender) >= paramStablecoinQuantityToBridge, "Not enought stablecoin balance.");
        // require(astarUsd(ASTARUSD_TOKEN_ADDRESS).allowance(msg.sender, address(this)) >= paramStablecoinQuantityToBridge, "Not enought allowance, please add more.");

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

    function bridgeStablecoinComposeDeafult(uint256 paramStablecoinQuantityToBridge) external payable 
    {
        // require(astarUsd(ASTARUSD_TOKEN_ADDRESS).balanceOf(msg.sender) >= paramStablecoinQuantityToBridge, "Not enought stablecoin balance.");
        // require(astarUsd(ASTARUSD_TOKEN_ADDRESS).allowance(msg.sender, address(this)) >= paramStablecoinQuantityToBridge, "Not enought allowance, please add more.");

        bytes memory options = OptionsBuilder.newOptions().addExecutorLzComposeOption(0, 30000, 0);

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

    function bridgeStablecoinDropDeafult(uint256 paramStablecoinQuantityToBridge, bytes32 receiverAddressInBytes32) external payable 
    {
        // require(astarUsd(ASTARUSD_TOKEN_ADDRESS).balanceOf(msg.sender) >= paramStablecoinQuantityToBridge, "Not enought stablecoin balance.");
        // require(astarUsd(ASTARUSD_TOKEN_ADDRESS).allowance(msg.sender, address(this)) >= paramStablecoinQuantityToBridge, "Not enought allowance, please add more.");

        // bytes memory options = OptionsBuilder.newOptions().addExecutorLzComposeOption(0, 300000, 0);
        bytes memory options = OptionsBuilder.newOptions().addExecutorNativeDropOption(100000, receiverAddressInBytes32);

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


    function bridgeStablecoinReceiveManual(uint256 paramStablecoinQuantityToBridge, uint128 _gas, uint128 _value) external payable 
    {
        // require(astarUsd(ASTARUSD_TOKEN_ADDRESS).balanceOf(msg.sender) >= paramStablecoinQuantityToBridge, "Not enought stablecoin balance.");
        // require(astarUsd(ASTARUSD_TOKEN_ADDRESS).allowance(msg.sender, address(this)) >= paramStablecoinQuantityToBridge, "Not enought allowance, please add more.");

        // bytes memory options = OptionsBuilder.newOptions().addExecutorLzComposeOption(0, 300000, 0);
        bytes memory options = OptionsBuilder.newOptions().addExecutorLzReceiveOption(_gas, _value);

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

    function bridgeStablecoinComposeManual(uint256 paramStablecoinQuantityToBridge, uint16 _index, uint128 _gas, uint128 _value) external payable 
    {
        // require(astarUsd(ASTARUSD_TOKEN_ADDRESS).balanceOf(msg.sender) >= paramStablecoinQuantityToBridge, "Not enought stablecoin balance.");
        // require(astarUsd(ASTARUSD_TOKEN_ADDRESS).allowance(msg.sender, address(this)) >= paramStablecoinQuantityToBridge, "Not enought allowance, please add more.");

        bytes memory options = OptionsBuilder.newOptions().addExecutorLzComposeOption(_index, _gas, _value);

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

    function bridgeStablecoinDropManual(uint256 paramStablecoinQuantityToBridge, uint128 _amount, bytes32 _receiver) external payable 
    {
        // require(astarUsd(ASTARUSD_TOKEN_ADDRESS).balanceOf(msg.sender) >= paramStablecoinQuantityToBridge, "Not enought stablecoin balance.");
        // require(astarUsd(ASTARUSD_TOKEN_ADDRESS).allowance(msg.sender, address(this)) >= paramStablecoinQuantityToBridge, "Not enought allowance, please add more.");

        // bytes memory options = OptionsBuilder.newOptions().addExecutorLzComposeOption(0, 300000, 0);
        bytes memory options = OptionsBuilder.newOptions().addExecutorNativeDropOption(_amount, _receiver);

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