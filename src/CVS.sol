// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.18;
pragma experimental ABIEncoderV2;

import {console} from "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {VM_ADDRESS} from "src/Constants.sol";

// Cross-Version Solidity Helper Library
library CVS {
    Vm internal constant vm = Vm(VM_ADDRESS);

    /**
     * @notice Shortcut to deploy a contract without arguments.
     * @param artifact Artifact to deploy, must be compatbile with vm.getCode.
     * @return Address of the deployed contract.
     */
    function deploy(string memory artifact) internal returns (address) {
        return deploy(artifact, bytes(""));
    }

    /**
     * @notice Shortcut to deploy a contract without arguments, to a specific address.
     * @param target The address to deploy to.
     * @param artifact Artifact to deploy, must be compatbile with vm.getCode.
     */
    function deployTo(address target, string memory artifact) internal {
        deployTo(target, artifact, bytes(""));
    }

    /**
     * @notice Deploy a contract specifified by the foundry artifact and constructor arguments.
     * @param artifact Artifact to deploy, must be compatbile with vm.getCode.
     * @param args Arguments to pass to the contract constructor.
     * @return addr Address of the deployed contracts.
     */
    function deploy(string memory artifact, bytes memory args) internal returns (address addr) {
        bytes memory bytecode = abi.encodePacked(vm.getCode(artifact), args);

        // solhint-disable-next-line no-inline-assembly
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }
        vm.label(addr, artifact);
        return addr;
    }

    /**
     * @notice Deploy a contract specifified by the foundry artifact and constractor arguments to a specific address.
     * @param target The address to deploy to.
     * @param artifact Artifact to deploy, must be compatbile with vm.getCode.
     * @param args Arguments to pass to the contract constructor.
     */
    function deployTo(address target, string memory artifact, bytes memory args) internal {
        bytes memory creationCode = vm.getCode(artifact);
        vm.etch(target, abi.encodePacked(creationCode, args));
        (bool success, bytes memory runtimeBytecode) = target.call("");
        require(success, "deployTo(address,string,bytes): Failed to create runtime bytecode.");
        vm.label(target, artifact);
        vm.etch(target, runtimeBytecode);
    }
}
