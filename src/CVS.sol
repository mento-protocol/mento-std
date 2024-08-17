// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.18;
pragma experimental ABIEncoderV2;

import {console} from "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {VM_ADDRESS} from "src/Constants.sol";

// Cross-Version Solidity Helper Library
library CVS {
    Vm internal constant vm = Vm(VM_ADDRESS);

    function deploy(string memory contractPath) internal returns (address) {
        return deploy(contractPath, abi.encodePacked());
    }

    function deployTo(address target, string memory contractPath) internal {
        deployTo(target, contractPath, abi.encodePacked());
    }

    function deploy(
        string memory contractPath,
        bytes memory args
    ) internal returns (address addr) {
        bytes memory bytecode = abi.encodePacked(
            vm.getCode(contractPath),
            args
        );

        // solhint-disable-next-line no-inline-assembly
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }
        return addr;
    }

    function deployTo(
        address target,
        string memory contractPath,
        bytes memory args
    ) internal {
        bytes memory creationCode = vm.getCode(contractPath);
        vm.etch(target, abi.encodePacked(creationCode, args));
        (bool success, bytes memory runtimeBytecode) = target.call("");
        require(
            success,
            "deployTo(address,string,bytes): Failed to create runtime bytecode."
        );
        vm.etch(target, runtimeBytecode);
    }
}
