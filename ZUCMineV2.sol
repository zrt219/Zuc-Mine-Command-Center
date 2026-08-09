// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * @title  ZUCMineV2
 * @notice Upgraded on-chain uranium mining protocol & operational telemetry registry.
 *         Introduces Role-Based Access Control (RBAC), multi-metric telemetry, 
 *         batch reading capabilities, and $ZUC Raw Ore ERC-20 token rewards.
 */
contract ZUCMineV2 {

    /* ─── CONSTANTS & ROLES ─── */

    bytes32 public constant ADMIN_ROLE    = keccak256("ADMIN_ROLE");
    bytes32 public constant ORACLE_ROLE   = keccak256("ORACLE_ROLE");
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");

    /* ─── STRUCTS ─── */

    struct Miner {
        uint256 id;
        string  name;
        uint256 oreMined; // cumulative ore mined in tons
        address wallet;   // miner wallet address
    }

    enum MineStatus { Active, Maintenance, Depleted, Decommissioned }

    struct MineTelemetry {
        uint256 id;
        string  name;
        uint256 reserveTons;
        uint256 dailyExtractionRate;
        uint256 radiationLevelPpm;
        uint256 activeLaborers;
        MineStatus status;
        uint256 lastUpdated;
    }

    /* ─── STATE VARIABLES ─── */

    address public owner;
    
    // RBAC mappings
    mapping(bytes32 => mapping(address => bool)) private _roles;

    // V1 Compatibility Mappings
    mapping(uint256 => Miner)   public miners;
    mapping(uint256 => string)  public mineNames;
    mapping(uint256 => uint256) public mineReserves;
    uint256 public minerCount;

    // V2 Enhanced State
    mapping(uint256 => MineTelemetry) public mineTelemetry;
    uint256 public mineCount;

    // $ZUC Token Balances (ERC-20 lightweight internal ledger)
    string public constant tokenName = "ZUC Uranium Ore";
    string public constant tokenSymbol = "ZUC";
    uint8  public constant decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    /* ─── EVENTS ─── */

    // V1 Events
    event MinerAdded(uint256 indexed minerId, string name, uint256 oreMined);
    event MineNameSet(uint256 indexed mineId, string name);
    event ReservesStored(uint256 indexed mineId, uint256 tons);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // V2 Events
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
    event TelemetryUpdated(uint256 indexed mineId, uint256 reserveTons, uint256 dailyRate, uint256 radiationPpm, uint256 activeLaborers, MineStatus status);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OreTokenMinted(address indexed to, uint256 amount, string reason);

    /* ─── ERRORS ─── */

    error NotAuthorized(bytes32 requiredRole);
    error NotOwner();
    error ZeroAddress();
    error InsufficientBalance();

    /* ─── MODIFIERS ─── */

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    modifier onlyRole(bytes32 role) {
        if (!_roles[role][msg.sender] && msg.sender != owner) revert NotAuthorized(role);
        _;
    }

    /* ─── CONSTRUCTOR ─── */

    constructor() {
        owner = msg.sender;
        _roles[ADMIN_ROLE][msg.sender] = true;
        _roles[ORACLE_ROLE][msg.sender] = true;
        _roles[OPERATOR_ROLE][msg.sender] = true;

        // Initialize default mines
        _initMine(0, "Sub-Sector Alpha", 450000, 1200, 42, 18);
        _initMine(1, "Sub-Sector Beta", 820000, 2400, 58, 34);
        _initMine(2, "Sub-Sector Gamma", 190000, 650, 85, 12);
    }

    /* ─── RBAC MANAGEMENT ─── */

    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role][account] || account == owner;
    }

    function grantRole(bytes32 role, address account) external onlyOwner {
        if (account == address(0)) revert ZeroAddress();
        _roles[role][account] = true;
        emit RoleGranted(role, account, msg.sender);
    }

    function revokeRole(bytes32 role, address account) external onlyOwner {
        _roles[role][account] = false;
        emit RoleRevoked(role, account, msg.sender);
    }

    /* ─── V1 WRITE FUNCTIONS (Full Backward Compatibility) ─── */

    function addMiner(string calldata _name, uint256 _oreMined) public onlyRole(OPERATOR_ROLE) {
        uint256 id = minerCount++;
        miners[id] = Miner({id: id, name: _name, oreMined: _oreMined, wallet: msg.sender});
        emit MinerAdded(id, _name, _oreMined);

        // Mint $ZUC bonus tokens (1 ton = 100 $ZUC tokens)
        uint256 mintAmount = _oreMined * 100 * 10**18;
        if (mintAmount > 0) {
            _mint(msg.sender, mintAmount, "Miner Registration Production Bonus");
        }
    }

    function setMineName(uint256 _mineId, string calldata _name) public onlyRole(OPERATOR_ROLE) {
        mineNames[_mineId] = _name;
        mineTelemetry[_mineId].name = _name;
        emit MineNameSet(_mineId, _name);
    }

    function storeReserves(uint256 _mineID, uint256 _tons) public onlyRole(ORACLE_ROLE) {
        mineReserves[_mineID] = _tons;
        mineTelemetry[_mineID].reserveTons = _tons;
        mineTelemetry[_mineID].lastUpdated = block.timestamp;
        emit ReservesStored(_mineID, _tons);
    }

    function transferOwnership(address _newOwner) external onlyOwner {
        if (_newOwner == address(0)) revert ZeroAddress();
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
        _roles[ADMIN_ROLE][_newOwner] = true;
    }

    /* ─── V2 TELEMETRY FUNCTIONS ─── */

    function updateTelemetry(
        uint256 _mineId,
        uint256 _reserveTons,
        uint256 _dailyExtractionRate,
        uint256 _radiationLevelPpm,
        uint256 _activeLaborers,
        MineStatus _status
    ) external onlyRole(ORACLE_ROLE) {
        mineReserves[_mineId] = _reserveTons;
        
        mineTelemetry[_mineId] = MineTelemetry({
            id: _mineId,
            name: bytes(mineNames[_mineId]).length > 0 ? mineNames[_mineId] : string(abi.encodePacked("Mine #", _uint2Str(_mineId))),
            reserveTons: _reserveTons,
            dailyExtractionRate: _dailyExtractionRate,
            radiationLevelPpm: _radiationLevelPpm,
            activeLaborers: _activeLaborers,
            status: _status,
            lastUpdated: block.timestamp
        });

        if (_mineId >= mineCount) {
            mineCount = _mineId + 1;
        }

        emit ReservesStored(_mineId, _reserveTons);
        emit TelemetryUpdated(_mineId, _reserveTons, _dailyExtractionRate, _radiationLevelPpm, _activeLaborers, _status);
    }

    /* ─── ERC-20 LIGHTWEIGHT TOKEN FUNCTIONS ─── */

    function transfer(address recipient, uint256 amount) external returns (bool) {
        if (balanceOf[msg.sender] < amount) revert InsufficientBalance();
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        if (balanceOf[sender] < amount) revert InsufficientBalance();
        if (allowance[sender][msg.sender] < amount) revert InsufficientBalance();
        
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function _mint(address to, uint256 amount, string memory reason) internal {
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
        emit OreTokenMinted(to, amount, reason);
    }

    /* ─── BATCH & MULTICALL VIEW FUNCTIONS ─── */

    function getMinersBatch(uint256 offset, uint256 limit) 
        external 
        view 
        returns (Miner[] memory batch) 
    {
        if (offset >= minerCount) {
            return new Miner[](0);
        }
        uint256 end = offset + limit;
        if (end > minerCount) {
            end = minerCount;
        }
        uint256 resultSize = end - offset;
        batch = new Miner[](resultSize);
        for (uint256 i = 0; i < resultSize; i++) {
            batch[i] = miners[offset + i];
        }
    }

    function getAllTelemetry() external view returns (MineTelemetry[] memory allTelemetry) {
        allTelemetry = new MineTelemetry[](mineCount);
        for (uint256 i = 0; i < mineCount; i++) {
            allTelemetry[i] = mineTelemetry[i];
        }
    }

    function getMineInfo(uint256 _mineId) external view returns (uint256 tons, string memory name) {
        tons = mineReserves[_mineId];
        name = mineNames[_mineId];
    }

    function getMiner(uint256 _minerID) external view returns (Miner memory) {
        return miners[_minerID];
    }

    function getReserves(uint256 _mineID) external view returns (uint256) {
        return mineReserves[_mineID];
    }

    /* ─── INTERNAL HELPERS ─── */

    function _initMine(
        uint256 _id, 
        string memory _name, 
        uint256 _reserves, 
        uint256 _rate, 
        uint256 _rad, 
        uint256 _laborers
    ) internal {
        mineNames[_id] = _name;
        mineReserves[_id] = _reserves;
        mineTelemetry[_id] = MineTelemetry({
            id: _id,
            name: _name,
            reserveTons: _reserves,
            dailyExtractionRate: _rate,
            radiationLevelPpm: _rad,
            activeLaborers: _laborers,
            status: MineStatus.Active,
            lastUpdated: block.timestamp
        });
        if (_id >= mineCount) {
            mineCount = _id + 1;
        }
    }

    function _uint2Str(uint256 _i) internal pure returns (string memory str) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 len;
        while (j != 0) { len++; j /= 10; }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k--;
            uint8 temp = (uint8)(48 + _i % 10);
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
