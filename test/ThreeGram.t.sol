// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ThreeGram.sol";

contract ThreeGramTest is Test {
    ThreeGram public threegram;
    address public constant alice = address(0x1);

    event CreateUser(
        address indexed _wallet,
        string indexed _username,
        string _name,
        string indexed _bio,
        string _avatar
    );

    event CreatePost(
        address indexed _author,
        string indexed _title,
        string indexed _media
    );

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
        emit CreateUser(
            alice,
            "testUsername",
            "testName",
            "test bio",
            "testAvatar"
        );
        threegram.createUser(
            "testUsername",
            "testName",
            "test bio",
            "testAvatar"
        );
    }

    function testCreatePost_revertsWithEmptyTitle() public {
        vm.startPrank(alice);
        threegram.createUser(
            "testUsername",
            "testName",
            "test bio",
            "testAvatar"
        );
        vm.expectRevert("Post can't be empty!");
        threegram.createPost("", "");
    }

    function testCreatePost_revertsIfNotAUser() public {
        vm.expectRevert("Must be a user!");
        threegram.createPost("This is a test title", "https://example.com");
    }

    function testCreatePost() public {
        vm.startPrank(alice);
        threegram.createUser(
            "testUsername",
            "testName",
            "test bio",
            "testAvatar"
        );
        vm.expectEmit(true, true, true, true, address(threegram));
        emit CreatePost(alice, "This is a test title", "https://example.com");
        threegram.createPost("This is a test title", "https://example.com");
    }

    function testGetPosts_returnsZeroInitially() public {
        ThreeGram.Post[] memory _posts = threegram.getPosts();
        assertTrue(_posts.length == 0);
    }

    function testGetPosts_returnsCorrectLength() public {
        threegram.createUser(
            "testUsername",
            "testName",
            "test bio",
            "testAvatar"
        );
        threegram.createPost("This is a test title", "https://example.com");
        ThreeGram.Post[] memory _posts = threegram.getPosts();

        assertTrue(_posts.length > 0);
        assertTrue(_posts.length == 1);
    }
}
