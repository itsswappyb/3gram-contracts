// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {ThreeGram} from "src/ThreeGram.sol";

contract ThreeGramScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        new ThreeGram();
        vm.stopBroadcast();
    }
}
