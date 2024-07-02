
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Telephone} from "../src/Telephone.sol";

contract DeployTelephone is Script {

    Telephone telephone;
    address public owner = makeAddr("owner");

    function run() external returns(Telephone) {
        vm.startBroadcast(owner);
        telephone = new Telephone();
        vm.stopBroadcast();
        return telephone;
    }

}
