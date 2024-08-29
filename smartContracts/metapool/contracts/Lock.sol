// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

interface metapool
{
    function totalAssets() external returns (uint256 assets);
    function depositETH(address _receiver) external payable returns (uint256);
}

contract metaTest
{
    // mpEth TOKEN: 0xe50339fE67402Cd59c32656D679479801990579f
    uint256 public assetsValue;
    address public METAPOOL_STAKING_AND_MPETH_TOKEN_ADDRESS = 0xe50339fE67402Cd59c32656D679479801990579f;


    function getAssetsValueProxy() public returns(uint256)
    {
        return metapool(METAPOOL_STAKING_AND_MPETH_TOKEN_ADDRESS).totalAssets();
    }

    function getAndUpdateAssetsValueProxy() public
    {
        uint256 value = metapool(METAPOOL_STAKING_AND_MPETH_TOKEN_ADDRESS).totalAssets();
        assetsValue = value;
    }

    function depositEthProxy() public payable
    {
        metapool(METAPOOL_STAKING_AND_MPETH_TOKEN_ADDRESS).depositETH{value: msg.value}(msg.sender);
    }
}