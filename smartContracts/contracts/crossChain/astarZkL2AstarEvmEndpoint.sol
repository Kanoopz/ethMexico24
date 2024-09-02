//SPDX-License-Identifier: MIT

import { OApp, Origin, MessagingFee } from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { OptionsBuilder } from "@layerzerolabs/oapp-evm/contracts/oapp/libs/OptionsBuilder.sol";

pragma solidity 0.8.24;

interface zkL2AstarUsd
{
    function mint(address to, uint256 amount) external;
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function burnFrom(address account, uint256 value) external;
}

contract astarZkL2AstarEvmEndpoint is OApp
{
    using OptionsBuilder for bytes;


    uint32 public ASTAR_EVM_SHIBUYA_EID = 40210;
    address public ZK_L2_ASTAR_USD_ADDRESS;

    constructor() OApp(0x6EDCE65403992e310A62460808c4b910D972f10f, msg.sender) Ownable(msg.sender)
    {}


    function setZkL2AstarUsd(address paramZkL2AstarUsdAddress) external onlyOwner
    {
        ZK_L2_ASTAR_USD_ADDRESS = paramZkL2AstarUsdAddress;
    }

    function bridgeBackStablecoin(uint256 paramStablecoinQuantityToBridge) external payable 
    {
        require(zkL2AstarUsd(ZK_L2_ASTAR_USD_ADDRESS).balanceOf(msg.sender) >= paramStablecoinQuantityToBridge, "Not enought stablecoin balance.");
        require(zkL2AstarUsd(ZK_L2_ASTAR_USD_ADDRESS).allowance(msg.sender, address(this)) >= paramStablecoinQuantityToBridge, "Not enought allowance, please add more.");

        zkL2AstarUsd(ZK_L2_ASTAR_USD_ADDRESS).burnFrom(msg.sender, paramStablecoinQuantityToBridge);

        bytes memory options = OptionsBuilder.newOptions().addExecutorLzReceiveOption(50000, 0);

        bytes memory _payload = abi.encode(msg.sender, paramStablecoinQuantityToBridge);

        _lzSend(
            ASTAR_EVM_SHIBUYA_EID,
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
    ) internal override 
    {
        (address addressToMint, uint256 quantityToMint) = abi.decode(payload, (address, uint256));
        zkL2AstarUsd(ZK_L2_ASTAR_USD_ADDRESS).mint(addressToMint, quantityToMint);
    }
}