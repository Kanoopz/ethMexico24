// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;

import "./coreUsd.sol";


interface coreStakingSC
{
    function depositCore(address _receiver) external payable returns (uint256);
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

contract coreVault
{
    address public ST_CORE_TOKEN_ADDRESS = 0xb3A8F0f0da9ffC65318aA39E55079796093029AD;
    address public CORE_PRICE_PAIR_ADDRESS;

    coreUsd coreUsdToken;


    mapping(address => uint) public userUsedStcorehToMintStablecoin;
    mapping(address => uint) public userstCoreOnVault;





    constructor()
    {
        coreUsdToken = new coreUsd(address(this));
    }



    function getCoreUsdPrice18Decimals() public view returns(uint)
    {
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = AggregatorV3Interface(CORE_PRICE_PAIR_ADDRESS).latestRoundData();

        return uint(answer * (10 ** 10));
    }

    function getCoreToStablecoin(uint paramCoreQuantityToUse) public view returns(uint)
    {
        uint collateralValue = (paramCoreQuantityToUse * getCoreUsdPrice18Decimals()) / (1 ether);
        uint usdToMint = collateralValue / 2;
        return usdToMint;
    }

    function mintCoreUsdStablecoin() public payable
    {
        uint liquidCore = coreStakingSC(ST_CORE_TOKEN_ADDRESS).depositCore{value: msg.value}(address(this));

        userUsedStcorehToMintStablecoin[msg.sender] += liquidCore;
        userstCoreOnVault[msg.sender] += liquidCore;

        uint coreUsdToMint = getCoreToStablecoin(msg.value);

        coreUsdToken.mint(msg.sender, coreUsdToMint);
    }

    function getCoreUsdStablecoinAddress() public view returns(address)
    {
        return coreUsdToken.getAddress();
    }
}