// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "solmate/tokens/ERC20.sol";

enum Lock {
    twoWeeks,
    oneMonth,
    threeMonths,
    sixMonths,
    twelveMonths
}

interface AtlasMine {
    function deposit(uint256 _amount, Lock _lock) external;

    function withdrawPosition(uint256 _depositId, uint256 _amount)
        external
        returns (bool);

    function withdrawAll() external;

    function harvestPosition(uint256 _depositId) external;

    function harvestAll() external;

    function withdrawAndHarvestPosition(uint256 _depositId, uint256 _amount)
        external;

    function withdrawAndHarvestAll() external;

    function currentId(address) external returns (uint256);
}

contract MagicStakePool {
    ERC20 public magicToken;
    AtlasMine public atlasMine;

    mapping (uint256 => address) public depositIdToUser;
    uint256 public currentDepositId;

    event Deposit(address indexed user, uint256 indexed index, uint256 amount, Lock lock);

    constructor(ERC20 _magicToken, AtlasMine _atlasMine) {
        magicToken = _magicToken;
        atlasMine = _atlasMine;
    }

    function deposit(uint256 _amount) external {
        // Transfer $MAGIC from user
        magicToken.transferFrom(msg.sender, address(this), _amount);

        // Approve and transfer $MAGIC to Atlas Mine
        magicToken.approve(address(atlasMine), _amount);
        atlasMine.deposit(_amount, Lock.twoWeeks);
        
        // Record user deposit
        uint256 depositId = atlasMine.currentId(address(this));
        depositIdToUser[depositId] = msg.sender;
        currentDepositId = depositId;
        emit Deposit(msg.sender, depositId, _amount, Lock.twoWeeks);
    }

    function withdraw(uint256 _depositId) external {
        // Get starting balance
        uint256 startingMagicBalance = magicToken.balanceOf(address(this));

        // Withdraw and harvest all $MAGIC for this this position
        atlasMine.withdrawAndHarvestPosition(_depositId, type(uint256).max);
        uint256 harvestedMagicBalance = magicToken.balanceOf(address(this)) - startingMagicBalance;

        // Send $MAGIC to user
        magicToken.transfer(msg.sender, harvestedMagicBalance);

        // Remove deposit record
        delete depositIdToUser[_depositId]; 
    }
}
