// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ThreeGram.sol";

contract ThreeGramTest is Test {
    ThreeGram public threegram;
    address public constant alice = address(0x1);

    event CreateUser(address indexed _wallet, string indexed _username);

    function setUp() public {
        threegram = new ThreeGram();
    }

    function testOwner() public {
        address _owner = threegram.owner();
        assertEq(_owner, address(this));
    }

    function testPaused() public {
        assertFalse(threegram.paused());
    }

    function testCreateUser_revertsIfAddressTaken() public {
        threegram.createUser(
            "testUsername",
            "testName",
            "test bio",
            "testAvatar"
        );

        vm.startPrank(alice);
        vm.expectRevert("Address taken!");
        threegram.createUser(
            "testUsername",
            "testName",
            "test bio",
            "testAvatar"
        );
    }

    function testCreateUser_revertsIfAlreadyUser() public {
        threegram.createUser(
            "testUsername",
            "testName",
            "test bio",
            "testAvatar"
        );
        vm.expectRevert("Already a user!");
        threegram.createUser(
            "testUsername",
            "testName",
            "test bio",
            "testAvatar"
        );
    }

    function testCreateUser() public {
        vm.prank(alice);
        vm.expectEmit(true, true, true, true, address(threegram));
        emit CreateUser(alice, "testUsername");
        threegram.createUser(
            "testUsername",
            "testName",
            "test bio",
            "testAvatar"
        );
    }
}
