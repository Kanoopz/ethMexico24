// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.24;

import { OApp, Origin, MessagingFee } from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract infraLayerZero is OApp 
{
    constructor(address _endpoint, address _owner) OApp(_endpoint, _owner) Ownable(_owner) 
    {}

    /**
     * @notice Sends a message from the source to destination chain.
     * @param _dstEid Destination chain's endpoint ID.
     * @param _message The message to send.
     * @param _options Message execution options (e.g., for sending gas to destination).
     */
    function send(
        uint32 _dstEid,
        string memory _message,
        bytes calldata _options
    ) public payable virtual
    {}
    // {
    //     // Encodes the message before invoking _lzSend.
    //     // Replace with whatever data you want to send!
    //     bytes memory _payload = abi.encode(_message);
        
    //     _lzSend(
    //         _dstEid,
    //         _payload,
    //         _options,
    //         // Fee in native gas and ZRO token.
    //         MessagingFee(msg.value, 0),
    //         // Refund address in case of failed source message.
    //         payable(msg.sender)
    //     );
    // }

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
    ) internal override virtual
    {}
    // {
    //     // Decode the payload to get the message
    //     // In this case, type is string, but depends on your encoding!
    //     data = abi.decode(payload, (string));
    // }



    receive() external payable 
    {}
}