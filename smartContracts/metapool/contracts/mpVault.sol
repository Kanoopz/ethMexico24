// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;

import "./mpUsd.sol";


interface metapoolStakingSC
{
    function totalAssets() external returns (uint256 assets);
    function depositETH(address _receiver) external payable returns (uint256);
}

interface AggregatorV3Interface 
{
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

contract mpVault
{
    // mpEth TOKEN: 0xe50339fE67402Cd59c32656D679479801990579f
    uint256 public assetsValue;

    address public METAPOOL_STAKING_AND_MPETH_TOKEN_ADDRESS = 0xe50339fE67402Cd59c32656D679479801990579f;
    address public ETH_USD_PAIR_PRICE_FEED_ADDRESS = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

    mpUsd metapoolUsd;


    mapping(address => uint) public userUsedMpethToMintStablecoin;
    mapping(address => uint) public userMpethOnVault;





    constructor()
    {
        metapoolUsd = new mpUsd(address(this));
    }



    function getEthUsdPrice18Decimals() public view returns(uint)
    {
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = AggregatorV3Interface(ETH_USD_PAIR_PRICE_FEED_ADDRESS).latestRoundData();

        return uint(answer * (10 ** 10));
    }

    function getEthToStablecoin(uint paramEthQuantityToUse) public view returns(uint)
    {
        uint collateralValue = (paramEthQuantityToUse * getEthUsdPrice18Decimals()) / (1 ether);
        uint usdToMint = collateralValue / 2;
        return usdToMint;
    }

    function mintMpUsdStablecoin() public payable
    {
        uint liquidEther = metapoolStakingSC(METAPOOL_STAKING_AND_MPETH_TOKEN_ADDRESS).depositETH{value: msg.value}(address(this));

        userUsedMpethToMintStablecoin[msg.sender] += liquidEther;
        userMpethOnVault[msg.sender] += liquidEther;

        uint mpUsdToMint = getEthToStablecoin(msg.value);

        metapoolUsd.mint(msg.sender, mpUsdToMint);
    }

    function getMpUsdStablecoinAddress() public view returns(address)
    {
        return metapoolUsd.getAddress();
    }





    function getAssetsValueProxy() public returns(uint256)
    {
        return metapoolStakingSC(METAPOOL_STAKING_AND_MPETH_TOKEN_ADDRESS).totalAssets();
    }

    function getAndUpdateAssetsValueProxy() public
    {
        uint256 value = metapoolStakingSC(METAPOOL_STAKING_AND_MPETH_TOKEN_ADDRESS).totalAssets();
        assetsValue = value;
    }

    function depositEthProxy() public payable
    {
        metapoolStakingSC(METAPOOL_STAKING_AND_MPETH_TOKEN_ADDRESS).depositETH{value: msg.value}(msg.sender);
    }
}