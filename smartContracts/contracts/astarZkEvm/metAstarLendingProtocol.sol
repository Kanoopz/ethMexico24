//SPDX-License-Identifier: MIT

import "./shareToken.sol";
import "@api3/contracts/api3-server-v1/proxies/interfaces/IProxy.sol";

pragma solidity 0.8.24;

contract metAstarLendingProtocol
{
    struct positionData
    {
        uint positionId;
        address borrower;
        uint collateralUsed18Decimals;
        uint wBtcPriceAtBorrowing;
        uint collateralValueAtBorrowing;
        uint liquidationPrice;
        uint usdBorrowedType; // 0: astarUsd, 1: mpUsd ///
        uint usdBorrowedAmount;
        uint timestamp;
        uint pendingDebt;
        uint pendingCollateralToGetBack;
        bool liquidated;
    }

    address ASTAR_ZKEVM_ORACLE_ADDRESS = 0x73AB44615772a0d31dB48A87d7F4F81a3601BceB;
    address ASTAR_USD_ADDRESS = 0x8d1f6698C2dee8ADf1A53582D096AD7a7030afFa;
    address MP_USD_ADDRESS = 0x8c0a3f863Bef1F709FA3F7f42eD9Efd8FEF6D6fC;
    address WRAPPED_BTC_TOKEN_ADDERSS = 0x182426cdEAfe2E6877915D7A68165d313Ca93F87;

    uint totalAstarUsdDeposited;
    uint totalMpUsdDeposited;
    uint availableAstarUsdReserve;
    uint availableMpUsdReserve;

    uint nextPositionId = 1;

    shareToken astarUsdShareToken;
    shareToken mpUsdShareToken;

    mapping(uint => positionData) borrowPositionsData;
    mapping(address => uint) lenderDepositedAstarUsd;
    mapping(address => uint) lenderDepositedMpUsd;
    mapping(address => uint) borrowerCollateralInProtocol;





    constructor()
    {
        astarUsdShareToken = new shareToken("astarUsdShareToken", "astarSt"); //("astarUsdShareToken", "astarSt");
        mpUsdShareToken = new shareToken("mpUsdShareToken", "mpSt"); //("mpUsdShareToken", "mpSt");
    }

    function getWrappedBtcPrice18Decimals() public view returns(uint)
    {
        (int224 value,uint32 timestamp) = IProxy(ASTAR_ZKEVM_ORACLE_ADDRESS).read();

        return uint(int256(value));
    }

    function depositAstarLiquidity(uint paramAstarUsdAmountToDeposit) public
    {
        require(IERC20(ASTAR_USD_ADDRESS).allowance(msg.sender, address(this)) >= paramAstarUsdAmountToDeposit, "Not enough allowance. Plase allow the protocol to use more astarUsd.");

        IERC20(ASTAR_USD_ADDRESS).transferFrom(msg.sender, address(this), paramAstarUsdAmountToDeposit);

        lenderDepositedAstarUsd[msg.sender] += paramAstarUsdAmountToDeposit;
        totalAstarUsdDeposited += paramAstarUsdAmountToDeposit;
        availableAstarUsdReserve += paramAstarUsdAmountToDeposit;

        astarUsdShareToken.mint(msg.sender, paramAstarUsdAmountToDeposit);
    }

    function depositMpLiquidity(uint paramMpUsdAmountToDeposit) public
    {
        require(IERC20(MP_USD_ADDRESS).allowance(msg.sender, address(this)) >= paramMpUsdAmountToDeposit, "Not enough allowance. Plase allow the protocol to use more mpUsd.");

        IERC20(MP_USD_ADDRESS).transferFrom(msg.sender, address(this), paramMpUsdAmountToDeposit);

        lenderDepositedMpUsd[msg.sender] += paramMpUsdAmountToDeposit;
        totalMpUsdDeposited += paramMpUsdAmountToDeposit;
        availableMpUsdReserve += paramMpUsdAmountToDeposit;

        mpUsdShareToken.mint(msg.sender, paramMpUsdAmountToDeposit);
    }

    function redeemAstarUsd(uint paramAstarUsdAmountToRedeem) public
    {
        require(lenderDepositedAstarUsd[msg.sender] >= paramAstarUsdAmountToRedeem, "Incorrect amount to redeem, the specified amount is bigger.");
        require(availableAstarUsdReserve >= paramAstarUsdAmountToRedeem, "Not enough liquidity.");

        // CALCULAR USER SHARES ///
        uint userShares = astarUsdShareToken.balanceOf(msg.sender);
        uint sharesTotalSupply = astarUsdShareToken.totalSupply();

        // a - totalShares  ->   b - 100
        // c - userShares   ->   x - ?

        // x = (b * c) / a  ->   ? = (100 * userShares) / totalShares
        uint userSharesPercentage = (100 * paramAstarUsdAmountToRedeem) / sharesTotalSupply;


        // a - 100                   ->   b - total_jericho_deposited
        // c - userSharesPercentage  ->   x - ?

        // x = (b * c) / a  ->   ? = (total_jericho_deposited * userSharesPercentage) / 100
        uint toRedeemPlusAccruedFees = (totalAstarUsdDeposited * userSharesPercentage) / 100;

        astarUsdShareToken.adminBurn(msg.sender, userShares);

        totalAstarUsdDeposited -= paramAstarUsdAmountToRedeem;
        availableAstarUsdReserve -= toRedeemPlusAccruedFees;
        lenderDepositedAstarUsd[msg.sender] -= paramAstarUsdAmountToRedeem;

        IERC20(ASTAR_USD_ADDRESS).transfer(msg.sender, toRedeemPlusAccruedFees);
    }

    function redeemMpUsd(uint paramMpUsdAmountToRedeem) public
    {
        require(lenderDepositedMpUsd[msg.sender] >= paramMpUsdAmountToRedeem, "Incorrect amount to redeem, the specified amount is bigger.");
        require(availableMpUsdReserve >= paramMpUsdAmountToRedeem, "Not enough liquidity.");

        // CALCULAR USER SHARES ///
        uint userShares = mpUsdShareToken.balanceOf(msg.sender);
        uint sharesTotalSupply = mpUsdShareToken.totalSupply();

        // a - totalShares  ->   b - 100
        // c - userShares   ->   x - ?

        // x = (b * c) / a  ->   ? = (100 * userShares) / totalShares
        uint userSharesPercentage = (100 * paramMpUsdAmountToRedeem) / sharesTotalSupply;


        // a - 100                   ->   b - total_jericho_deposited
        // c - userSharesPercentage  ->   x - ?

        // x = (b * c) / a  ->   ? = (total_jericho_deposited * userSharesPercentage) / 100
        uint toRedeemPlusAccruedFees = (totalMpUsdDeposited * userSharesPercentage) / 100;

        mpUsdShareToken.adminBurn(msg.sender, userShares);

        totalMpUsdDeposited -= paramMpUsdAmountToRedeem;
        availableMpUsdReserve -= toRedeemPlusAccruedFees;
        lenderDepositedMpUsd[msg.sender] -= paramMpUsdAmountToRedeem;

        IERC20(ASTAR_USD_ADDRESS).transfer(msg.sender, toRedeemPlusAccruedFees);
    }

    function borrowAstarUsd(uint paramWBtcCollateralToUse) public
    {
        require(IERC20(WRAPPED_BTC_TOKEN_ADDERSS).allowance(msg.sender, address(this)) >= paramWBtcCollateralToUse, "Not enough allowance. Plase allow the protocol to use more wBtc.");

        IERC20(WRAPPED_BTC_TOKEN_ADDERSS).transferFrom(msg.sender, address(this), paramWBtcCollateralToUse);

        borrowerCollateralInProtocol[msg.sender] = paramWBtcCollateralToUse;

        uint wBtcPrice = getWrappedBtcPrice18Decimals();
        uint collateralValue = (wBtcPrice * paramWBtcCollateralToUse) / 1000000000000;
        uint collateralLiquidationPrice = (wBtcPrice * 85) / 100;
        uint amountToBorrow = (collateralValue * 80) / 100;

        require(availableAstarUsdReserve >= amountToBorrow, "Not enough astarUsd reserve liquidity.");

        availableAstarUsdReserve -= amountToBorrow;
        
        uint actualTimestamp = block.timestamp;

        positionData memory positionInfo = positionData(nextPositionId, msg.sender, paramWBtcCollateralToUse, wBtcPrice, collateralValue, collateralLiquidationPrice, 0, amountToBorrow, actualTimestamp, amountToBorrow, paramWBtcCollateralToUse, false);
        borrowPositionsData[nextPositionId] = positionInfo;
        nextPositionId++;

        IERC20(ASTAR_USD_ADDRESS).transfer(msg.sender, amountToBorrow);
    }

    function borrowMpUsd(uint paramWBtcCollateralToUse) public
    {
        require(IERC20(WRAPPED_BTC_TOKEN_ADDERSS).allowance(msg.sender, address(this)) >= paramWBtcCollateralToUse, "Not enough allowance. Plase allow the protocol to use more wBtc.");

        IERC20(WRAPPED_BTC_TOKEN_ADDERSS).transferFrom(msg.sender, address(this), paramWBtcCollateralToUse);

        borrowerCollateralInProtocol[msg.sender] = paramWBtcCollateralToUse;

        uint wBtcPrice = getWrappedBtcPrice18Decimals();
        uint collateralValue = (wBtcPrice * paramWBtcCollateralToUse) / 1000000000000;
        uint collateralLiquidationPrice = (wBtcPrice * 85) / 100;
        uint amountToBorrow = (collateralValue * 80) / 100;

        require(availableMpUsdReserve >= amountToBorrow, "Not enough mpUsd reserve liquidity.");

        availableMpUsdReserve -= amountToBorrow;
        
        uint actualTimestamp = block.timestamp;

        positionData memory positionInfo = positionData(nextPositionId, msg.sender, paramWBtcCollateralToUse, wBtcPrice, collateralValue, collateralLiquidationPrice, 0, amountToBorrow, actualTimestamp, amountToBorrow, paramWBtcCollateralToUse, false);
        borrowPositionsData[nextPositionId] = positionInfo;
        nextPositionId++;

        IERC20(MP_USD_ADDRESS).transfer(msg.sender, amountToBorrow);
    }

    function repayPosition(uint positionToRepayId, uint paramUsdToRepay) public
    {
        require(positionToRepayId > nextPositionId, "positionId doesnt exist.");
        require(!(borrowPositionsData[positionToRepayId].liquidated), "Position already liquidated.");

        uint usdType = borrowPositionsData[positionToRepayId].usdBorrowedType;
        address usdAddress;

        if(usdType == 0)
        {
            usdAddress = ASTAR_USD_ADDRESS;
        }
        else if(usdType == 1)
        {
            usdAddress = MP_USD_ADDRESS;
        }

        require(IERC20(usdAddress).allowance(msg.sender, address(this)) >= paramUsdToRepay, "Not enough allowance. Plase allow the protocol to use more.");

        IERC20(usdAddress).transferFrom(msg.sender, address(this), paramUsdToRepay);

        uint apy = 1000;
        uint actualTimestamp = block.number;
        uint timePassed = actualTimestamp - borrowPositionsData[positionToRepayId].timestamp;
        uint YEAR = 60 * 60 * 24 * 365;
        uint totalApy = (apy * timePassed) / YEAR;
        uint toRepay = ((borrowPositionsData[positionToRepayId].pendingDebt) * (10000 + totalApy) / 10000) + 1;
        
        if(paramUsdToRepay >= toRepay)
        {
            if(usdType == 0)
            {
                availableAstarUsdReserve += paramUsdToRepay;
            }
            else if(usdType == 1)
            {
                availableMpUsdReserve += paramUsdToRepay;
            }

            borrowPositionsData[positionToRepayId].pendingDebt = 0;
            borrowPositionsData[positionToRepayId].pendingCollateralToGetBack = 0;
            borrowPositionsData[positionToRepayId].liquidated = true;

            uint collateralPending = borrowPositionsData[positionToRepayId].pendingCollateralToGetBack;
            IERC20(WRAPPED_BTC_TOKEN_ADDERSS).transfer(msg.sender, collateralPending);
        }
        else
        {
            uint collateralToReturn = (paramUsdToRepay * borrowPositionsData[positionToRepayId].pendingCollateralToGetBack) / toRepay;

            if(usdType == 0)
            {
                availableAstarUsdReserve += paramUsdToRepay;
            }
            else if(usdType == 1)
            {
                availableMpUsdReserve += paramUsdToRepay;
            }

            uint payingDebt = (borrowPositionsData[positionToRepayId].pendingDebt * paramUsdToRepay) / toRepay;

            borrowPositionsData[positionToRepayId].pendingDebt -= payingDebt;
            borrowPositionsData[positionToRepayId].pendingCollateralToGetBack -= collateralToReturn;

            IERC20(WRAPPED_BTC_TOKEN_ADDERSS).transfer(msg.sender, collateralToReturn);
        }
    }

    function liquidate(uint paramPositionIdToLiquidate) public
    {
        require(paramPositionIdToLiquidate > nextPositionId, "positionId doesnt exist.");
        require(!borrowPositionsData[paramPositionIdToLiquidate].liquidated, "Position already liquidated.");

        uint actualBtcPrice = getWrappedBtcPrice18Decimals();

        require(actualBtcPrice < borrowPositionsData[paramPositionIdToLiquidate].liquidationPrice, "Position not ready to be liquidated.");

        uint usdType = borrowPositionsData[paramPositionIdToLiquidate].usdBorrowedType;
        address usdAddress;

        if(usdType == 0)
        {
            usdAddress = ASTAR_USD_ADDRESS;
        }
        else if(usdType == 1)
        {
            usdAddress = MP_USD_ADDRESS;
        }

        uint amountToPay = borrowPositionsData[paramPositionIdToLiquidate].pendingDebt;
        uint collateralAmount = borrowPositionsData[paramPositionIdToLiquidate].pendingCollateralToGetBack;

        require(IERC20(usdAddress).allowance(msg.sender, address(this)) >= amountToPay, "Not enough allowance. Plase allow the protocol to use more usd.");
        IERC20(usdAddress).transferFrom(msg.sender, address(this), amountToPay);
        IERC20(WRAPPED_BTC_TOKEN_ADDERSS).transfer(msg.sender, collateralAmount);

        if(usdType == 0)
        {
            availableAstarUsdReserve += amountToPay;
        }
        else if(usdType == 1)
        {
            availableMpUsdReserve += amountToPay;
        }

        borrowPositionsData[paramPositionIdToLiquidate].liquidated = true;
    }

    function calculateBorrowAmountApproximately(uint paramCollateralQuantity) public view returns(uint)
    {
        uint btcPrice = getWrappedBtcPrice18Decimals();
        uint collateralValue = (btcPrice * paramCollateralQuantity) / 1000000000000;
        uint borrowingAmount = (collateralValue * 70) / 100;

        return borrowingAmount;
    }

    function getAstarUsdLiquidityReserves() public view returns(uint)
    {
        return availableAstarUsdReserve;
    }

    function getMpUsdLiquidityReserves() public view returns(uint)
    {
        return availableMpUsdReserve;
    }

    function getNumberOfPositions() public view returns(uint)
    {
        return (nextPositionId - 1);
    }
    
    function getPositionData(uint paramPositionId) public view returns(positionData memory)
    {
        return borrowPositionsData[paramPositionId];
    }

    function isLiquidated(uint paramPostionId) public view returns(bool)
    {
        return borrowPositionsData[paramPostionId].liquidated;
    }

    function isReadyToBeLiquidated(uint paramPositionIdToLiquidate) public view returns(bool)
    {
        uint wBtcPrice = getWrappedBtcPrice18Decimals();
        return (wBtcPrice < borrowPositionsData[paramPositionIdToLiquidate].liquidationPrice);
    }
}