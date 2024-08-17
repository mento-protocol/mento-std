// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8;

import {console} from "forge-std/console.sol";

import {Vm} from "forge-std/Vm.sol";
import {StdChains} from "forge-std/StdChains.sol";
import {VM_ADDRESS} from "./Constants.sol";

import {CeloChains} from "./CeloChains.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {IRegistry} from "./interfaces/IRegistry.sol";
import {CELO_REGISTRY_ADDRESS} from "./Constants.sol";
import {toString} from "./Utils.sol";

struct CreateTx {
    address contractAddress;
    string contractName;
}

struct Result {
    CreateTx[] txs;
}

abstract contract Contracts is CeloChains {
    using stdJson for string;

    Vm private constant vm = Vm(VM_ADDRESS);
    IRegistry private constant celoRegistry = IRegistry(CELO_REGISTRY_ADDRESS);

    mapping(bytes32 contractName => address contractAddress) private contractAddress;
    string private dependencies;

    mapping(bytes32 contractName => bytes getterCallData) private governanceFactoryLookupCalldata;

    // @dev To be overriden by implementing contract.
    function dependenciesPath() internal virtual returns (string memory);

    constructor() {
        string memory root = vm.projectRoot();
        string memory path = string(abi.encodePacked(root, dependenciesPath()));
        dependencies = vm.readFile(path);
        governanceFactoryLookupCalldata[keccak256("MentoToken")] = abi.encodeWithSignature("mentoToken()");
        governanceFactoryLookupCalldata[keccak256("Emission")] = abi.encodeWithSignature("emission()");
        governanceFactoryLookupCalldata[keccak256("GovernanceTimelock")] =
            abi.encodeWithSignature("governanceTimelock()");
        governanceFactoryLookupCalldata[keccak256("MentoGovernor")] = abi.encodeWithSignature("mentoGovernor()");
        governanceFactoryLookupCalldata[keccak256("Locking")] = abi.encodeWithSignature("locking()");
        governanceFactoryLookupCalldata[keccak256("Airgrab")] = abi.encodeWithSignature("airgrab()");
    }

    function load(string memory script, string memory timestamp) internal {
        load(script, timestamp, true);
    }

    function load(string memory script, string memory timestamp, bool silent) internal {
        string memory root = vm.projectRoot();
        string memory path = string(
            abi.encodePacked(
                root, "/broadcast/", script, ".sol/", toString(block.chainid), "/", "run-", timestamp, ".json"
            )
        );

        string memory json = vm.readFile(path);
        bytes memory contractAddressesRaw =
            vm.parseJson(json, "$.transactions[?(@.transactionType == 'CREATE')].contractAddress");
        address[] memory contractAddresses = abi.decode(contractAddressesRaw, (address[]));
        bytes memory contractNamesRaw =
            vm.parseJson(json, "$.transactions[?(@.transactionType == 'CREATE')].contractName");
        string[] memory contractNames = abi.decode(contractNamesRaw, (string[]));
        for (uint256 i = 0; i < contractAddresses.length; i++) {
            contractAddress[keccak256(bytes(contractNames[i]))] = contractAddresses[i];

            if (!silent) {
                console.log("Loaded contract %s at %s", contractNames[i], contractAddresses[i]);
            }
        }
    }

    function lookup(string memory contractName) internal view returns (address payable found) {
        address payable[] memory results = new address payable[](4);
        results[0] = _lookupDependencies(contractName);
        results[1] = _lookupDeployed(contractName);
        results[2] = _lookupCeloRegistry(contractName);
        results[3] = _lookupGovernanceFactory(contractName);

        bool foundMany = false;
        bool foundNone = true;
        for (uint256 i = 0; i < 4; i++) {
            if (results[i] != address(0) && found == address(0)) {
                found = results[i];
                foundNone = false;
            } else if (results[i] != address(0)) {
                foundMany = true;
            }
        }

        require(!foundNone, string(abi.encodePacked("Contracts: ", contractName, " not found in any source.")));

        if (foundMany) {
            console.log("Contract appears in multiple sources: ");
            if (results[0] != address(0)) {
                console.log("depndencies(%s): %s", contractName, results[0]);
            }
            if (results[1] != address(0)) {
                console.log("deployed(%s): %s", contractName, results[1]);
            }
            if (results[2] != address(0)) {
                console.log("celoRegistry(%s): %s", contractName, results[2]);
            }
            if (results[3] != address(0)) {
                console.log("governanceFactory(%s): %s", contractName, results[3]);
            }
        }

        require(!foundMany, string(abi.encodePacked("Contracts: ", contractName, " found in multiple sources")));
    }

    function lookupDeployed(string memory contractName) internal view returns (address payable addr) {
        addr = _lookupDeployed(contractName);
        require(
            addr != address(0),
            string(abi.encodePacked("Contracts: ", contractName, " not found in loaded deployment scripts."))
        );
    }

    function _lookupDeployed(string memory contractName) private view returns (address payable addr) {
        addr = payable(contractAddress[keccak256(bytes(contractName))]);
    }

    function lookupCeloRegistry(string memory contractName) internal view returns (address payable addr) {
        addr = _lookupCeloRegistry(contractName);
        require(
            addr != address(0), string(abi.encodePacked("Contracts: ", contractName, " not found in Celo registry."))
        );
    }

    function _lookupCeloRegistry(string memory contractName) private view returns (address payable) {
        return payable(celoRegistry.getAddressForString(contractName));
    }

    function lookupDependencies(string memory contractName) internal view returns (address payable addr) {
        addr = _lookupDependencies(contractName);
        require(
            addr != address(0), string(abi.encodePacked("Contracts: ", contractName, " not found in dependencies."))
        );
    }

    function _lookupDependencies(string memory contractName) private view returns (address payable) {
        bytes memory contractAddressRaw = dependencies.parseRaw(
            // solhint-disable-next-line quotes
            string(abi.encodePacked('["', toString(block.chainid), '"]', '["', contractName, '"]'))
        );

        if (contractAddressRaw.length != 32) {
            return payable(address(0));
        }
        return abi.decode(contractAddressRaw, (address));
    }

    function lookupGovernanceFactory(string memory contractName) internal view returns (address payable addr) {
        addr = _lookupGovernanceFactory(contractName);
        require(
            addr != address(0),
            string(abi.encodePacked("Contracts: ", contractName, " not found in GovernanceFactory."))
        );
    }

    function _lookupGovernanceFactory(string memory contractName) private view returns (address payable addr) {
        address governanceFactory = _lookupDependencies("GovernanceFactory");
        if (governanceFactory == address(0)) return payable(address(0));

        bytes memory getter = governanceFactoryLookupCalldata[keccak256(bytes(contractName))];

        if (getter.length == 0) return payable(address(0));

        (bool ok, bytes memory data) = governanceFactory.staticcall(getter);
        if (ok) {
            addr = abi.decode(data, (address));
        }
    }
}
