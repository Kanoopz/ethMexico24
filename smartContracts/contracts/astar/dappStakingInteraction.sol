//SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import "./dappStakingPrecompile.sol";

contract dappStakingInteraction
{
    enum Subperiod 
    {
        Voting, BuildAndEarn
    }

    struct ProtocolState 
    {
        uint256 era;
        uint256 period;
        Subperiod subperiod;
    }

    ProtocolState public protocolStateValue;
    uint public unlockingPeriodValue;

    dappStakingPrecompile public constant DAPPS_STAKING = dappStakingPrecompile(0x0000000000000000000000000000000000005001);

    // function getProtocolStateValue() public view returns(ProtocolState memory)
    // {
    //     ProtocolState calldata value = DAPPS_STAKING.protocol_state();
    // }

    // function getAndUpdateProtocolStateValue() public view returns(ProtocolState memory)
    // {
    //     return DAPPS_STAKING.protocol_state();
    // }

    function getUnlockingPeriod() public view returns(uint)
    {
        return DAPPS_STAKING.unlocking_period();
    }

    function getAndUpdateUnlockingPeriod() public
    {
        uint value = DAPPS_STAKING.unlocking_period();
        unlockingPeriodValue = value;
    }
}