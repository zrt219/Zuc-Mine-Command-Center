// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * @title  ZUCMine
 * @notice On-chain uranium mine registry deployed on the XRPL EVM Sidechain.
 *         Tracks miners, mine names, and ore reserves across a network of mines.
 *
 * @dev    Deployed at: 0x22ACA8269801bF50d96c7e7F296c11799597bE31
 *         Network:     XRPL EVM Sidechain Testnet (Chain ID: 1449000)
 *         Explorer:    https://explorer.testnet.xrplevm.org/address/0x22ACA8269801bF50d96c7e7F296c11799597bE31
 */
contract ZUCMine {

    /* ─── STRUCTS ─── */

    struct Miner {
        uint256 id;
        string  name;
        uint256 oreMined; // cumulative ore mined in tons
    }

    /* ─── STATE ─── */

    address public owner;

    mapping(uint256 => Miner)  public miners;
    mapping(uint256 => string) public mineNames;
    mapping(uint256 => uint256) public mineReserves;

    uint256 public minerCount;

    /* ─── EVENTS ─── */

    event MinerAdded(uint256 indexed minerId, string name, uint256 oreMined);
    event MineNameSet(uint256 indexed mineId, string name);
    event ReservesStored(uint256 indexed mineId, uint256 tons);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /* ─── ERRORS ─── */

    error NotOwner();
    error ZeroAddress();

    /* ─── MODIFIERS ─── */

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    /* ─── CONSTRUCTOR ─── */

    constructor() {
        owner = msg.sender;
    }

    /* ─── WRITE FUNCTIONS ─── */

    /**
     * @notice Register a new miner with their cumulative ore production.
     * @param  _name     Miner display name.
     * @param  _oreMined Cumulative ore mined in tons.
     */
    function addMiner(string calldata _name, uint256 _oreMined) public onlyOwner {
        uint256 id = minerCount++;
        miners[id] = Miner({id: id, name: _name, oreMined: _oreMined});
        emit MinerAdded(id, _name, _oreMined);
    }

    /**
     * @notice Set or update the display name of a mine.
     * @param  _mineId Target mine ID.
     * @param  _name   New mine name.
     */
    function setMineName(uint256 _mineId, string calldata _name) public onlyOwner {
        mineNames[_mineId] = _name;
        emit MineNameSet(_mineId, _name);
    }

    /**
     * @notice Record ore reserves for a mine.
     * @param  _mineID Target mine ID.
     * @param  _tons   Reserve tonnage to store.
     */
    function storeReserves(uint256 _mineID, uint256 _tons) public onlyOwner {
        mineReserves[_mineID] = _tons;
        emit ReservesStored(_mineID, _tons);
    }

    /**
     * @notice Transfer contract ownership.
     * @param  _newOwner New owner address.
     */
    function transferOwnership(address _newOwner) external onlyOwner {
        if (_newOwner == address(0)) revert ZeroAddress();
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }

    /* ─── VIEW FUNCTIONS ─── */

    /**
     * @notice Get mine name and reserve tonnage.
     * @param  _mineId Target mine ID.
     * @return tons    Current reserve in tons.
     * @return name    Mine display name.
     */
    function getMineInfo(uint256 _mineId)
        external
        view
        returns (uint256 tons, string memory name)
    {
        tons = mineReserves[_mineId];
        name = mineNames[_mineId];
    }

    /**
     * @notice Get full miner struct by ID.
     * @param  _minerID Target miner ID.
     * @return Miner struct (id, name, oreMined).
     */
    function getMiner(uint256 _minerID)
        external
        view
        returns (Miner memory)
    {
        return miners[_minerID];
    }

    /**
     * @notice Get ore reserves for a specific mine.
     * @param  _mineID Target mine ID.
     * @return Reserve tonnage.
     */
    function getReserves(uint256 _mineID)
        external
        view
        returns (uint256)
    {
        return mineReserves[_mineID];
    }
}
