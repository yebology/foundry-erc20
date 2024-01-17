// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { OurToken } from "../src/OurToken.sol";
import { Test } from "forge-std/Test.sol";
import { DeployOurToken } from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {

    OurToken public ot;
    DeployOurToken public deployer;

    address bob = makeAddr("Bob");
    address alice = makeAddr("Alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ot = deployer.run();

        vm.prank(msg.sender);
        ot.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ot.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;
        uint256 transferAmount = 500;

        vm.prank(bob);
        ot.approve(alice, initialAllowance); // Bob approves Alice to spend his token on her behalf

        vm.prank(alice);
        ot.transferFrom(bob, alice, transferAmount); // transferFrom can set anybody from to transfer, but it only go through if they are approved

        assertEq(ot.balanceOf(alice), transferAmount);
        assertEq(ot.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }
}