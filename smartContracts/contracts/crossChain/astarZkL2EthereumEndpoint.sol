//SPDX-License-Identifier: MIT

import { OApp, Origin, MessagingFee } from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { OptionsBuilder } from "@layerzerolabs/oapp-evm/contracts/oapp/libs/OptionsBuilder.sol";

pragma solidity 0.8.24;

interface zkL2MpUsd
{
    function mint(address to, uint256 amount) external;
}

contract astarZkL2EthereumEndpoint is OApp
{
    using OptionsBuilder for bytes;


    uint32 public ETHEREUM_SEPOLIA_EID = 40161;
    address public ZK_L2_MP_USD_ADDRESS;

    constructor() OApp(0x6EDCE65403992e310A62460808c4b910D972f10f, msg.sender) Ownable(msg.sender)
    {}


    function setZkL2MpUsd(address paramZkL2MpUsdAddress) external onlyOwner
    {
        ZK_L2_MP_USD_ADDRESS = paramZkL2MpUsdAddress;
    }

    function bridgeBackStablecoin(uint256 paramStablecoinQuantityToBridge) external payable 
    {
        // require(mpUsd(MPUSD_TOKEN_ADDRESS).balanceOf(msg.sender) >= paramStablecoinQuantityToBridge, "Not enought stablecoin balance.");
        // require(mpUsd(MPUSD_TOKEN_ADDRESS).allowance(msg.sender, address(this)) >= paramStablecoinQuantityToBridge, "Not enought allowance, please add more.");

        // bytes memory options = OptionsBuilder.newOptions().addExecutorLzComposeOption(0, 300000, 0);
        // bytes memory options = OptionsBuilder.newOptions().addExecutorLzReceiveOption(50000, 0);

        // bytes memory _payload = abi.encode(msg.sender, paramStablecoinQuantityToBridge);

        // _lzSend(
        //     ETHEREUM_SEPOLIA_EID,
        //     _payload,
        //     options,
        //     // Fee in native gas and ZRO token.
        //     MessagingFee(msg.value, 0),
        //     // Refund address in case of failed source message.
        //     payable(msg.sender)
        // );

        string memory str = "ESTO DE AQUI ES PARA QUEMARLO.";
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
        zkL2MpUsd(ZK_L2_MP_USD_ADDRESS).mint(addressToMint, quantityToMint);
    }
}