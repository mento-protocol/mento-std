// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8;

import {console} from "forge-std/console.sol";
import {CeloChains} from "src/CeloChains.sol";
import {Script} from "src/Script.sol";

contract ExampleScript is Script {
    function dependenciesPath() internal pure override returns (string memory) {
        return "/test/fixtures/dependencies.json";
    }

    function run() public {
        console.log(isCelo());
        console.log(deployerAddress());
    }
}
