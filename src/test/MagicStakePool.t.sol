// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import {BaseTest, console} from "./base/BaseTest.sol";

import "../MagicStakePool.sol";

contract MagicStakePoolTest is BaseTest {
    address private MAGIC_TOKEN = 0x539bdE0d7Dbd336b79148AA742883198BBF60342;
    address private ATLAS_MINE = 0xA0A89db1C899c49F98E6326b764BAFcf167fC2CE;
    address private MAGIC_WHALE = 0x7B660FBafdADF78aB7bfe83475841712ae774066;

    MagicStakePool private pool;

    function setUp() public {
        pool = new MagicStakePool(ERC20(MAGIC_TOKEN), AtlasMine(ATLAS_MINE));
        vm.startPrank(MAGIC_WHALE); // Pretend to be a $MAGIC Whale 🐳
    }

    function testUserCanDeposit() public {
        ERC20 magic = ERC20(MAGIC_TOKEN);
        uint256 atlasStartingBalance = magic.balanceOf(ATLAS_MINE);
        magic.approve(address(pool), 100 ether);
        pool.deposit(100 ether);
        assertGt(magic.balanceOf(ATLAS_MINE), atlasStartingBalance);
    }

    function testFailWithdrawBeforeMaturity() public {
        ERC20 magic = ERC20(MAGIC_TOKEN);
        magic.approve(address(pool), 100 ether);
        pool.deposit(100 ether);
        
        uint256 depositId = pool.currentDepositId();
        pool.withdraw(depositId);
    }

    function testUserCanWithdrawAfterTwoWeeks() public {
        ERC20 magic = ERC20(MAGIC_TOKEN);
        magic.approve(address(pool), 100 ether);
        pool.deposit(100 ether);
        
        vm.warp(block.timestamp + 2 weeks);

        uint256 depositId = pool.currentDepositId();
        pool.withdraw(depositId);
    }

    function testCanChangeOwner() public {
        assertEq(address(this), pool.owner());
        vm.stopPrank();
        vm.prank(address(this));
        pool.changeOwner(address(123));
        assertEq(address(123), pool.owner());
    }

    function testFailChangeOwnerByNonOwner() public {
        vm.stopPrank();
        vm.prank(address(123));
        pool.changeOwner(address(123));
    }
}
