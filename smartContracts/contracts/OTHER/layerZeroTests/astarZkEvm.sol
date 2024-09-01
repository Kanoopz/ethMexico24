// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.24;

import { OApp, Origin, MessagingFee } from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { OptionsBuilder } from "@layerzerolabs/oapp-evm/contracts/oapp/libs/OptionsBuilder.sol";

contract astarZkEvm is OApp 
{
    using OptionsBuilder for bytes;

    constructor() OApp(0x6EDCE65403992e310A62460808c4b910D972f10f, msg.sender) Ownable(msg.sender)
    {}

    // Some arbitrary data you want to deliver to the destination chain!
    string public data;

    /**
     * @notice Sends a message from the source to destination chain.
     * @param _dstEid Destination chain's endpoint ID.
     * @param _message The message to send.
     */
    function sendReceive(
        uint32 _dstEid,
        string memory _message,
        // bytes calldata _options
        uint128 _gas,
        uint128 _value
    ) external payable 
    {
        // bytes memory options = OptionsBuilder.newOptions().addExecutorLzComposeOption(0, 300000, 0);
        bytes memory options = OptionsBuilder.newOptions().addExecutorLzReceiveOption(_gas, _value);

        // Encodes the message before invoking _lzSend.
        // Replace with whatever data you want to send!
        bytes memory _payload = abi.encode(_message);
        _lzSend(
            _dstEid,
            _payload,
            options,
            // Fee in native gas and ZRO token.
            MessagingFee(msg.value, 0),
            // Refund address in case of failed source message.
            payable(msg.sender)
        );
    }

    /**
     * @notice Sends a message from the source to destination chain.
     * @param _dstEid Destination chain's endpoint ID.
     * @param _message The message to send.
     */
    function sendCompose(
        uint32 _dstEid,
        string memory _message,
        // bytes calldata _options
        uint16 _index,
        uint128 _gas,
        uint128 _value
    ) external payable 
    {
        // bytes memory options = OptionsBuilder.newOptions().addExecutorLzComposeOption(0, 300000, 0);
        bytes memory options = OptionsBuilder.newOptions().addExecutorLzComposeOption(_index, _gas, _value);

        // Encodes the message before invoking _lzSend.
        // Replace with whatever data you want to send!
        bytes memory _payload = abi.encode(_message);
        _lzSend(
            _dstEid,
            _payload,
            options,
            // Fee in native gas and ZRO token.
            MessagingFee(msg.value, 0),
            // Refund address in case of failed source message.
            payable(msg.sender)
        );
    }

    /**
     * @notice Sends a message from the source to destination chain.
     * @param _dstEid Destination chain's endpoint ID.
     * @param _message The message to send.
     */
    function sendDrop(
        uint32 _dstEid,
        string memory _message,
        // bytes calldata _options
        uint128 _amount, 
        bytes32 _receiver
    ) external payable 
    {
        // bytes memory options = OptionsBuilder.newOptions().addExecutorLzComposeOption(0, 300000, 0);
        bytes memory options = OptionsBuilder.newOptions().addExecutorNativeDropOption(_amount, _receiver);

        // Encodes the message before invoking _lzSend.
        // Replace with whatever data you want to send!
        bytes memory _payload = abi.encode(_message);
        _lzSend(
            _dstEid,
            _payload,
            options,
            // Fee in native gas and ZRO token.
            MessagingFee(msg.value, 0),
            // Refund address in case of failed source message.
            payable(msg.sender)
        );
    }

    /**
     * @dev Called when data is received from the protocol. It overrides the equivalent function in the parent contract.
     * Protocol messages are defined as packets, comprised of the following parameters.
     * @param _origin A struct containing information about where the packet came from.
     * @param _guid A global unique identifier for tracking the packet.
     * @param payload Encoded message.
     */
    function _lzReceive(
        Origin calldata _origin,
        bytes32 _guid,
        bytes calldata payload,
        address,  // Executor address as specified by the OApp.
        bytes calldata  // Any extra data or options to trigger on receipt.
    ) internal override {
        // Decode the payload to get the message
        // In this case, type is string, but depends on your encoding!
        data = abi.decode(payload, (string));
    }
}