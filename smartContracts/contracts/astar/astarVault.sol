// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./astarUsd.sol";


interface nastrLiquidStakingSc
{
    function mintNote(address to, uint256 amount, string memory utility) external;
}

interface diaOracleInterface
{
    function getValue(string memory key) external view returns (uint128, uint128);
}

contract astarVault is Ownable
{
    address public NASTR_LIQUID_STAKING_AND_NASTR_TOKEN_ADDRESS;
    address public DIA_ORACLE_SC_ADDRESS = 0x1232AcD632Dd75f874E357c77295Da3f5Cd7733E;

    string public UTILITY_NOTE_DESCRIPTION = "AstrLiquidStaking";

    astarUsd astrUsd;


    mapping(address => uint) public userUsedNastrToMintStablecoin;
    mapping(address => uint) public userNastrOnVault;





    constructor() Ownable(msg.sender)
    {
        astrUsd = new astarUsd(address(this));
    }



    function getAstrPrice() public view returns(uint128)
    {
        (uint128 value, uint128 valueTwo) = diaOracleInterface(DIA_ORACLE_SC_ADDRESS).getValue("ASTR/USD");
        return value;
    }

    function getAstrPriceWith18Decimals() public view returns(uint)
    {
        uint128 value = getAstrPrice();
        uint value18Decimals = (uint(value) * (10 ** 10));

        return value18Decimals;
    }

    function getAstrToStablecoin(uint paramAstrQuantityToUse) public view returns(uint)
    {
        uint collateralValue = (paramAstrQuantityToUse * getAstrPriceWith18Decimals()) / (1 ether);
        uint usdToMint = collateralValue / 2;
        return usdToMint;
    }

    function setNastrLiquidStakingScAddress(address paramNastrScAddress) public onlyOwner
    {
        NASTR_LIQUID_STAKING_AND_NASTR_TOKEN_ADDRESS = paramNastrScAddress;
    }

    function mintAstarUsdStablecoin() public payable
    {
        uint nAstr = msg.value;
        string memory note = "liquidStakingCollateral";

        nastrLiquidStakingSc(NASTR_LIQUID_STAKING_AND_NASTR_TOKEN_ADDRESS).mintNote(address(this), msg.value, note);     //depositETH{value: msg.value}(address(this));

        userUsedNastrToMintStablecoin[msg.sender] += nAstr;
        userNastrOnVault[msg.sender] += nAstr;

        uint astarUsdToMint = getAstrToStablecoin(msg.value);

        astrUsd.mint(msg.sender, astarUsdToMint);
    }

    function getAstarUsdStablecoinAddress() public view returns(address)
    {
        return astrUsd.getAddress();
    }
}