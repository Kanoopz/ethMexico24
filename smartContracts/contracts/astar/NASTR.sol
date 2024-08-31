//SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

interface IERC20 
{

    /// @param _owner The address from which the balance will be retrieved
    /// @return balance the balance
    function balanceOf(address _owner) external view returns (uint256 balance);

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return success Whether the transfer was successful or not
    function transfer(address _to, uint256 _value)  external returns (bool success);

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return success Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);

    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of wei to be approved for transfer
    /// @return success Whether the approval was successful or not
    function approve(address _spender  , uint256 _value) external returns (bool success);

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return remaining Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract ERC20 is IERC20 
{
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;
    uint256 public totalSupply;

    string public name;                   
    uint8 public decimals;                
    string public symbol;                 

    constructor(string memory _tokenName, uint8 _decimalUnits, string  memory _tokenSymbol) 
    {
        name = _tokenName;                             
        decimals = _decimalUnits;                      
        symbol = _tokenSymbol;                          
    }

    function _mint(address to, uint256 amount) internal
    {
        balances[to] += amount;
        totalSupply += amount;
    }

    function transfer(address _to, uint256 _value) public override returns (bool success) 
    {
        require(balances[msg.sender] >= _value, "token balance is lower than the value requested");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value, "token balance or allowance is lower than amount requested");

        balances[_to] += _value;
        balances[_from] -= _value;

        allowed[_from][msg.sender] -= _value;


        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
        
        return true;
    }

    function balanceOf(address _owner) public override view returns (uint256 balance) 
    {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public override returns (bool success) 
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function allowance(address _owner, address _spender) public override view returns (uint256 remaining) 
    {
        return allowed[_owner][_spender];
    }
}


contract ERC20Burnable is ERC20 
{
    constructor(string memory _tokenName, uint8 _decimalUnits, string  memory _tokenSymbol) ERC20(_tokenName, _decimalUnits, _tokenSymbol)
    {}

    /**
     * @dev Destroys a `value` amount of tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(address account, uint256 value) internal 
    {
        _burn(account, value);
    }

    function _burn(address account, uint256 value) internal
    {
        balances[account] -= value;
        totalSupply -= value;
    }
}


library AddressUpgradeable {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly
                /// @solidity memory-safe-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/**
 * @dev String operations.
 */
library StringsUpgradeable {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
    uint8 private constant _ADDRESS_LENGTH = 20;

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    /**
     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
    }
}

contract liquidAstr is ERC20Burnable
{
    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {AccessControl-_setupRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);



    event OwnershipTransferred(address indexed owner, address indexed grantedOwner);
    
    address public distributor;
    address public owner;   // @notice stores current contract owner
    address private _grantedOwner;   // @notice needed to implement grant/claim ownership pattern

    bool private isNote;
    string private utilityToTransfer;

    /* unused */ uint256 counter;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
    bytes32 public constant DISTR_ROLE = keccak256("DISTR_ROLE");
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
    bytes32 public constant MULTITEST_ROLE = keccak256("MULTITEST_ROLE"); 


    struct RoleData 
    {
        mapping(address => bool) members;
        bytes32 adminRole;
    }

    mapping(bytes32 => RoleData) private _roles;

    modifier noteTransfer(string memory utility) 
    {
        utilityToTransfer = utility;
        isNote = true;
        _;
        isNote = false;
    }

    /**
     * @dev Modifier that checks that an account has a specific role. Reverts
     * with a standardized message including the required role.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     *
     * _Available since v4.1._
     */
    modifier onlyRole(bytes32 role) {
        _checkRole(role);
        _;
    }


    constructor(string memory _tokenName, uint8 _decimalUnits, string  memory _tokenSymbol) ERC20Burnable(_tokenName, _decimalUnits, _tokenSymbol)
    {}


    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view virtual returns (bytes32) {
        return _roles[role].adminRole;
    }


    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view virtual returns (bool) 
    {
        return _roles[role].members[account];
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleGranted} event.
     */
    function _grantRole(bytes32 role, address account) internal
    {
        if (!hasRole(role, account)) 
        {
            _roles[role].members[account] = true;
            emit RoleGranted(role, account, msg.sender);
        }
    }

    /**
     * @dev Revert with a standard message if `_msgSender()` is missing `role`.
     * Overriding this function changes the behavior of the {onlyRole} modifier.
     *
     * Format of the revert message is described in {_checkRole}.
     *
     * _Available since v4.6._
     */
    function _checkRole(bytes32 role) internal view virtual {
        _checkRole(role, msg.sender);
    }

    /**
     * @dev Revert with a standard message if `account` is missing `role`.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     */
    function _checkRole(bytes32 role, address account) internal view virtual {
        if (!hasRole(role, account)) {
            revert(
                string(
                    abi.encodePacked(
                        "AccessControl: account ",
                        StringsUpgradeable.toHexString(uint160(account), 20),
                        " is missing role ",
                        StringsUpgradeable.toHexString(uint256(role), 32)
                    )
                )
            );
        }
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleRevoked} event.
     */
    function _revokeRole(bytes32 role, address account) internal virtual {
        if (hasRole(role, account)) {
            _roles[role].members[account] = false;
        }
    }

    // @notice propose a new owner
    // @param _newOwner => new contract owner
    function grantOwnership(address _newOwner) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(_newOwner != address(0), "Zero address alarm!");
        require(_newOwner != owner, "Trying to set the same owner");
        _grantedOwner = _newOwner;
    }

    // @notice claim ownership by granted address
    function claimOwnership() external {
        require(_grantedOwner == msg.sender, "Caller is not the granted owner");
        _revokeRole(DEFAULT_ADMIN_ROLE, owner);
        _grantRole(DEFAULT_ADMIN_ROLE, _grantedOwner);
        owner = _grantedOwner;
        _grantedOwner = address(0);
        emit OwnershipTransferred(owner, _grantedOwner);
    }
}



pragma solidity 0.8.24;
interface dappStakingPrecompile 
{

    // Types

    /// Describes the subperiod in which the protocol currently is.
    enum Subperiod {Voting, BuildAndEarn}

    /// Describes current smart contract types supported by the network.
    enum SmartContractType {EVM, WASM}

    /// @notice Describes protocol state.
    /// @param era: Ongoing era number.
    /// @param period: Ongoing period number.
    /// @param subperiod: Ongoing subperiod type.
    struct ProtocolState 
    {
        uint256 era;
        uint256 period;
        Subperiod subperiod;
    }

    /// @notice Used to describe smart contract. Astar supports both EVM & WASM smart contracts
    ///         so it's important to differentiate between the two. This approach also allows
    ///         easy extensibility in the future.
    /// @param contract_type: Type of the smart contract to be used
    struct SmartContract 
    {
        SmartContractType contract_type;
        bytes contract_address;
    }

    // Storage getters

    /// @notice Get the current protocol state.
    /// @return (current era, current period number, current subperiod type).
    function protocol_state() external view returns (ProtocolState memory);

    /// @notice Get the unlocking period expressed in the number of blocks.
    /// @return period: The unlocking period expressed in the number of blocks.
    function unlocking_period() external view returns (uint256);


    // Extrinsic calls

    /// @notice Lock the given amount of tokens into dApp staking protocol.
    /// @param amount: The amount of tokens to be locked.
    function lock(uint128 amount) external returns (bool);

    /// @notice Start the unlocking process for the given amount of tokens.
    /// @param amount: The amount of tokens to be unlocked.
    function unlock(uint128 amount) external returns (bool);

    /// @notice Claims unlocked tokens, if there are any
    function claim_unlocked() external returns (bool);

    /// @notice Stake the given amount of tokens on the specified smart contract.
    ///         The amount specified must be precise, otherwise the call will fail.
    /// @param smart_contract: The smart contract to be staked on.
    /// @param amount: The amount of tokens to be staked.
    function stake(SmartContract calldata smart_contract, uint128 amount) external returns (bool);

    /// @notice Unstake the given amount of tokens from the specified smart contract.
    ///         The amount specified must be precise, otherwise the call will fail.
    /// @param smart_contract: The smart contract to be unstaked from.
    /// @param amount: The amount of tokens to be unstaked.
    function unstake(SmartContract calldata smart_contract, uint128 amount) external returns (bool);

    /// @notice Claims one or more pending staker rewards.
    function claim_staker_rewards() external returns (bool);

    /// @notice Claim the bonus reward for the specified smart contract.
    /// @param smart_contract: The smart contract for which the bonus reward should be claimed.
    function claim_bonus_reward(SmartContract calldata smart_contract) external returns (bool);

    /// @notice Claim dApp reward for the specified smart contract & era.
    /// @param smart_contract: The smart contract for which the dApp reward should be claimed.
    /// @param era: The era for which the dApp reward should be claimed.
    function claim_dapp_reward(SmartContract calldata smart_contract, uint256 era) external returns (bool);

    /// @notice Unstake all funds from the unregistered smart contract.
    /// @param smart_contract: The smart contract which was unregistered and from which all funds should be unstaked.
    function unstake_from_unregistered(SmartContract calldata smart_contract) external returns (bool);

    /// @notice Used to cleanup all expired contract stake entries from the caller.
    function cleanup_expired_entries() external returns (bool);
}




pragma solidity 0.8.24;

contract NASTR is liquidAstr
{
    using AddressUpgradeable for address;
    
    constructor() liquidAstr("nAstr", 18, "nAstr")
    {}

    function initialize(address _distributor) public 
    {
        require(_distributor.isContract(), "_distributor should be contract address");

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(DISTR_ROLE, _distributor);
        _grantRole(OWNER_ROLE, msg.sender);
    }

    // @param       issue DNT token
    // @param       [address] to => token reciever
    // @param       [uint256] amount => amount of tokens to issue
    function mintNote(address to, uint256 amount, string memory utility)
        external
        onlyRole(DISTR_ROLE)
        noteTransfer(utility)
    {
        _mint(to, amount);
    }

    /// @notice destroy DNT token
    /// @param account => token holder to burn from
    /// @param amount => amount of tokens to burn
    /// @param utility => utility to burn
    function burnNote(address account, uint256 amount, string memory utility)
        external
        onlyRole(DISTR_ROLE)
        noteTransfer(utility)
    {
        _burn(account, amount);
    }
}
