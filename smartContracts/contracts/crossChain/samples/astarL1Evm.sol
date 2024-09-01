//SPDX-License-Identifier: MIT

import "./layerZeroInfra.sol";

pragma solidity 0.8.24;

interface astarUsd
{
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}

contract astarL1Evm is infraLayerZero
{
    address public ASTAR_USD_ADDRESS;
    address public WHITELISTED_SOURCE_CHAIN;
    address public DESTINATION_CHAIN_ADDRESS;
    uint32 public DESTINATION_EID;

    constructor() infraLayerZero(0x6EDCE65403992e310A62460808c4b910D972f10f, msg.sender)
    {}

    function setDestinationChain(address paramDestinationAddress) public
    {
        DESTINATION_CHAIN_ADDRESS = paramDestinationAddress;
    }

    function setDestinationEid(uint32 paramDestinationEid) public
    {
        DESTINATION_EID = paramDestinationEid;
    }

    function depositTokens(uint paramTokenQuantityToDeposit) public
    {
        uint balance = astarUsd(ASTAR_USD_ADDRESS).balanceOf(msg.sender);
        uint allowance = astarUsd(ASTAR_USD_ADDRESS).allowance(msg.sender, address(this));

        require(balance >= paramTokenQuantityToDeposit, "User doesnt own enough tokens.");
        require(allowance >= paramTokenQuantityToDeposit, "Allowance not enough, please add more.");

        astarUsd(ASTAR_USD_ADDRESS).transferFrom(msg.sender, address(this), paramTokenQuantityToDeposit);
    }

    function send( uint32 _dstEid, uint paramTokensQuantity, address paramReceiverAddress, bytes calldata _options ) public payable 
    {
        bytes memory _payload = abi.encode(paramTokensQuantity, paramReceiverAddress);
        
        _lzSend(
            _dstEid,
            _payload,
            _options,
            // Fee in native gas and ZRO token.
            MessagingFee(msg.value, 0),
            // Refund address in case of failed source message.
            payable(msg.sender)
        );
    }
}