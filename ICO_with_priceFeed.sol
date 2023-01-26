// SPDX-License-Identifier: No License (None)

pragma solidity 0.8.17;



/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

abstract contract IERC223Recipient { 
/**
 * @dev Standard ERC223 function that will handle incoming token transfers.
 *
 * @param _from  Token sender address.
 * @param _value Amount of tokens.
 * @param _data  Transaction metadata.
 */
    function tokenReceived(address _from, uint _value, bytes memory _data) external virtual;
}

abstract contract MinterSetup {
    bool public setup_mode = true;
    mapping (address => bool) public minters;
    
    modifier onlyMinter()
    {
        require(minters[msg.sender], "Only minter is allowed to do this");
        _;
    }
    
    modifier onlySetupMode()
    {
        require(setup_mode, "This is only allowed in setup mode");
        _;
    }
}


/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC223 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);
    
    
    function transfer(address recipient, uint256 amount, bytes calldata data) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);
    event TransferData(bytes);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


/**
 * @dev Collection of functions related to the address type
 */
library Address {
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
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }
}

/**
 * @dev Implementation of the {IERC223} interface by @Dexaran. This contract
 * is intended to be backwards compatible with {IERC20} and {transferFrom},
 * {approve}, {increaseAllowance}, {decreaseAllowance} functions were
 * implemented for compatibility purposes.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 */
contract ERC223 is IERC223, MinterSetup {
    using Address for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory new_name, string memory new_symbol) {
        _name = new_name;
        _symbol = new_symbol;
        _decimals = 18;
    }
    
    function standard() public pure returns (string memory)
    {
        return "erc223";
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC223-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount, new bytes(0));
        return true;
    }

    /**
     * @dev See {IERC223-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     * 
     */
    function transfer(address recipient, uint256 amount, bytes calldata data) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount, data);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transferFrom(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] - subtractedValue);
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount, bytes memory data) internal virtual {
        require(sender != address(0), "ERC223: transfer from the zero address");
        require(recipient != address(0), "ERC223: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender] - amount;
        _balances[recipient] = _balances[recipient] + amount;
        
        if(recipient.isContract())
        {
            IERC223Recipient(recipient).tokenReceived(sender, amount, data);
        }
        emit Transfer(sender, recipient, amount);
        emit TransferData(data);
    }
    
    function _transferFrom(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC223: transfer from the zero address");
        require(recipient != address(0), "ERC223: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);
        
        _balances[sender] = _balances[sender] - amount;
        _balances[recipient] = _balances[recipient] + amount;
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] -= amount;
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address internal _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0) && newOwner != address(this), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


// GnG default ERC223 token.
contract GnGToken is ERC223("Games and Goblins token", "GnG"), Ownable {
    function rescueERC20(address token, address to) external onlyOwner {
        uint256 value = IERC223(token).balanceOf(address(this));
        IERC223(token).transfer(to, value);
    }
    
    // @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
    function mint(address _to, uint256 _amount) public onlyMinter {
        _mint(_to, _amount);
    }
    
    // An event thats emitted when assign a minter
    event AssignMinter(address minter, bool status);

    constructor() {
        address msgSender = msg.sender;
        _owner = msg.sender;
        _mint(msg.sender, 120000000 * 10 ** 18);
        emit OwnershipTransferred(address(0), msgSender);
    }
    
    function assignMinter(address _minter, bool _status) public onlyOwner onlySetupMode
    {
        minters[_minter] = _status;
        emit AssignMinter(_minter, _status);
    }
    
    function disableSetup() public onlyOwner onlySetupMode
    {
        setup_mode = false;
    }

    function getChainId() internal view returns (uint) {
        uint256 chainId;
        assembly { chainId := chainid() }
        return chainId;
    }
}

contract PriceFeed
{
    // returns token price in USD with 18 decimals
    function getPrice(address token) external view returns(uint256 price)
    {
        if(token==0x0000000000000000000000000000000000000001) return 3187227770000000; // CLO
        
        if(token==0xeb5B7d171d00e4Df2b3185e1e27f9f1A447200eF) return 9604863230000000; // SOY
        
        if(token==0x84a8509CbAa982A35fFbc3cd7c1eBbe9534b6C60) return 4756345080000000; 
    }
}

contract ICO is IERC223Recipient, Ownable, ReentrancyGuard
{
    string  public contractName = "NOT INITIALIZED";
    uint256 public min_purchase;  // Minimum amount of GNG tokens that a user must purchase.
    address public GnGToken_address;
    uint256 public start_timestamp;
    uint256 public end_timestamp;
    address public priceFeed = 0x9bFc3046ea26f8B09D3E85bd22AEc96C80D957e3; // Price Feed oracle. Address is valid for CLO mainnet.
    uint256 public tokenPricePer10000; // Price of 10000 GNG tokens in USD
                                       // value 300 would mean that 1 GNG = 0.03 USD.


    // This modifier prevents purchases that can be made before or after the ICO dates of the contract.
    // NOTE! this modifier allows the code of the function to execute first,
    //       therefore `owner` of the ICO contract will be able to deposit ERC223 GNG to the contract
    //       before the `ICO start date` and the `tokenReceived()` function will be invoked
    //       but it will end execution with `return` prior to the execution of the modifier code.
    modifier ICOstarted()
    {
        _;
        require(block.timestamp >= start_timestamp && block.timestamp <= end_timestamp, "Incorrect timing");
    }

    struct asset
    {
        // uint256 rate; // Determines how much GnG tokens a user will receive per 1000 "asset tokens" deposited.
        // bool native_currency; // true for CLO, false for tokens.


        address contract_address; // for tokens - address of the "asset token" contract.
        string name;  // Name of the accepted pair, for convenience purposes only.
    }

    mapping (uint256 => asset) public assets; // ID => asset_struct; ID = 0 is for native currency of the chain.
    mapping (address => uint256) public asset_index;  // address of token contract => ID of asset.

    constructor() {
        _owner = msg.sender;
        assets[0].name = "Native";
        assets[0].contract_address = 0x0000000000000000000000000000000000000001;
    }

    // This function accepts NATIVE CURRENCY (CLO on Callisto chain),
    // this function is used to purchase GNG tokens via CLO deposit.
    receive() external payable ICOstarted() nonReentrant()
    {
        require(PriceFeed(priceFeed).getPrice(0x0000000000000000000000000000000000000001) != 0, "Price Feed error");
        uint256 _refund_amount = 0;
        // User is buying GnG token and paying with a native currency.
            //uint256 _reward = assets[0].rate * msg.value / 1000; // Old calculation function for manual price update version.

            // `PriceFeedData/1e18 * msg.value / 1e18` ==>> This is value that was paid in USD
            // `USD value / tokenPricePer10000 * 10000 * 1e18` ==>> this is final value of the tokens that will be paid respecting decimals
            // since both PriceFeedData and GNG token have 18 decimals we will simply remove `/1e18` and `*1e18` from the equation.
            uint256 _reward = PriceFeed(priceFeed).getPrice(0x0000000000000000000000000000000000000001) * msg.value / tokenPricePer10000 * 10000 /1e18;

        // Check edge cases
        if(_reward > IERC223(GnGToken_address).balanceOf(address(this)))
        {
            uint256 _old_reward = _reward;
            _reward = IERC223(GnGToken_address).balanceOf(address(this));
            uint256 _reward_overflow = _reward - _old_reward;

            _refund_amount = (_reward_overflow * 10000 / tokenPricePer10000) / PriceFeed(priceFeed).getPrice(0x0000000000000000000000000000000000000001) /1e18;
        }

        require(_reward >= min_purchase, "Minimum purchase criteria is not met");
        IERC223(GnGToken_address).transfer(msg.sender, _reward);

        if(_refund_amount > 0)
        {
            payable(msg.sender).transfer(_refund_amount);
        }
    }

    function buy(address _token_contract, // Address of the contract of the token that will be deposited as the payment.
                 uint256 _value_to_deposit)          // How much tokens will be used to pay for acquiring tokens from ICO
                                          // IMPORTANT! This is not the amount of tokens that the user will receive,
                                          //            this is the amount of token that the user will PAY.
                                          //            The amount must be >= approved amount.
                 external ICOstarted() nonReentrant()
    {
        require(PriceFeed(priceFeed).getPrice(_token_contract) != 0, "Price Feed does not contain info about this token.");
        uint256 _refund_amount = 0;

        // PriceFeedData * _value_to_deposit / decimals ==>> 
        uint256 _reward = PriceFeed(priceFeed).getPrice(_token_contract) * _value_to_deposit / tokenPricePer10000 * 10000 /1e18;

        // Check edge cases
        if(_reward > IERC223(GnGToken_address).balanceOf(address(this)))
        {
            uint256 _old_reward = _reward;
            _reward = IERC223(GnGToken_address).balanceOf(address(this));
            uint256 _reward_overflow = _reward - _old_reward;

            //_refund_amount = _reward_overflow * 1000 / assets[asset_index[_token_contract]].rate; // Old calculation function
            _refund_amount = (_reward_overflow * 10000 / tokenPricePer10000) / PriceFeed(priceFeed).getPrice(_token_contract)/1e18;
        }


        IERC223(_token_contract).transferFrom(msg.sender, address(this), (_value_to_deposit - _refund_amount) );

        require(_reward >= min_purchase, "Minimum purchase criteria is not met");
        IERC223(GnGToken_address).transfer(msg.sender, _reward);
    }

    function tokenReceived(address _from, uint _value, bytes memory _data) external override ICOstarted() nonReentrant()
    {
        // Incoming transaction of a ERC223 token is handled here
        // here `msg.sender` is the address of the token contract which is being deposited
        //      `msg.value` = 0
        //      `_from` is the address of the user who initiated the transfer
        //      `_value` is the amount of ERC223 tokens being deposited.

        // Owner can deposit GNG token to the ICO contract and this function will be invoked.

        uint256 _refund_amount = 0;
        if(msg.sender == GnGToken_address && _from == owner())
        {
            // Deposit of GnG token by the owner. Do nothing and accept the deposit.
            // Stop execution preventing the execution of the ICOstarted() modifier.
            return;
        }
        if(asset_index[msg.sender] != 0)
        {
            require(PriceFeed(priceFeed).getPrice(msg.sender) != 0, "Price Feed does not contain info about this token.");
            // User is buying GnG token and paying with a token from "acceptable tokens list".
            //uint256 _reward = assets[asset_index[msg.sender]].rate * _value / 1000; // Old calculation function.
            uint256 _reward = PriceFeed(priceFeed).getPrice(msg.sender) * _value / tokenPricePer10000 * 10000 /1e18;

            // Check edge cases
            if(_reward > IERC223(GnGToken_address).balanceOf(address(this)))
                {
                uint256 _old_reward = _reward;
                _reward = IERC223(GnGToken_address).balanceOf(address(this));
                uint256 _reward_overflow = _reward - _old_reward;

                //_refund_amount = _reward_overflow * 1000 / assets[asset_index[msg.sender]].rate; // Old calculation funciton.
                _refund_amount = (_reward_overflow * 10000 / tokenPricePer10000) / PriceFeed(priceFeed).getPrice(msg.sender) /1e18;
            }

            require(_reward >= min_purchase, "Minimum purchase criteria is not met");
            IERC223(GnGToken_address).transfer(_from, _reward);

            if(_refund_amount > 0)
            {
                IERC223(msg.sender).transfer(_from, _refund_amount);
            }
        }
        else
        {
            // User is depositing a token which is not in "acceptable tokens list"
            // Revert transaction and stop the execution.
            revert();
        }
    }

    // Function that returns info about acceptable payment options
    // _id = 0 is for native currency (CLO).
    function get_depositable_asset(uint256 _id) external view returns (string memory name, uint256 rate, address token_contract)
    {
        return (assets[_id].name, PriceFeed(priceFeed).getPrice(assets[_id].contract_address), assets[_id].contract_address);
    }

    // This function serves the purpose of prediction of the reward that a user can acquire by depositing 
    // `_amount_of_payment` quantity of tokens `_token_address` to the contract
    function get_reward(uint256 _amount_of_payment, address _token_address) external view returns (uint256 reward, string memory name)
    {
        ///               3176591470000000   /1e18                           * 200 * 1e18         /  200 * 10000    
        uint256 _reward = PriceFeed(priceFeed).getPrice(_token_address) * _amount_of_payment / tokenPricePer10000 * 10000 / 1e18;
        return (_reward, assets[asset_index[_token_address]].name);
    }

    function modify_asset(uint256 _id, address _token_contract, string memory _name) external onlyOwner
    {
        // We are setting up the price for TOKEN that will be accepted as payment during ICO.
        require (_token_contract != address(0));
        assets[_id].contract_address = _token_contract;
        assets[_id].name = _name;
        asset_index[_token_contract] = _id;
    }

    // Special emergency function to rescue stuck ERC20 tokens that were accidentally deposited.
    function ERC20Rescue(address erc20token) public onlyOwner
    {
        IERC223(erc20token).transfer(owner(), IERC223(erc20token).balanceOf(address(this)));
    }

    // Function that allows owner to withdraw tokens.
    function withdraw(uint256 _id) public onlyOwner
    {
        if(_id == 0)
        {
            // Withdrawing native currency.
            payable(owner()).transfer(address(this).balance);
        }
        else
        {
            // Withdrawing a token.
            IERC223( assets[_id].contract_address ).transfer(owner(), IERC223( assets[_id].contract_address ).balanceOf( address(this) ));
        }
    }

    // Function that allows owner to withdraw tokens.
    function withdrawGNG(uint256 _amount) public onlyOwner
    {
        IERC223(GnGToken_address).transfer(owner(), _amount );
    }

    function setup_contract(address _GNG, uint256 _min_purchase, uint256 _start_UNIX, uint256 _end_UNIX, address _priceFeed, uint256 _targetPrice, string calldata _name) public onlyOwner
    {
        GnGToken_address   = _GNG;
        start_timestamp    = _start_UNIX;
        end_timestamp      = _end_UNIX;
        min_purchase       = _min_purchase;
        priceFeed          = _priceFeed;
        contractName       = _name;
        tokenPricePer10000 = _targetPrice;
    }

    // Emergency function that allows the owner of the contract to call any code
    // from any other "template contract" on behalf of the ICO contract.
    function delegateCall(address _to, bytes calldata _data) external onlyOwner
    {
        (bool success, bytes memory data) = _to.delegatecall(_data);
    }
}
