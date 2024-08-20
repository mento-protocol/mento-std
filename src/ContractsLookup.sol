// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8;

import {console} from "forge-std/console.sol";

import {Vm} from "forge-std/Vm.sol";
import {StdChains} from "forge-std/StdChains.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {CeloChains} from "./CeloChains.sol";
import {IRegistry} from "./interfaces/IRegistry.sol";
import {CELO_REGISTRY_ADDRESS, VM_ADDRESS} from "./Constants.sol";

/**
 * @title ContractsLookup
 * @notice Abstract contract that implements the logic to lookup contracts recorded in various sources.
 * It has four strategies to lookup contracts:
 * 1. From the dependencies.json file.
 * 2. From the contracts recorded in the broadcast scripts, and explicitly loaded by the `load` function.
 * 3. From the Celo registry.
 * 4. From the GovernanceFactory contract, if it can be found in (1) or (2).
 * @dev This contract is meant to be inherited by other contracts that need to lookup contracts.
 */
abstract contract ContractsLookup is CeloChains {
    using stdJson for string;

    /// @notice Interface to the Forge VM.
    Vm private constant vm = Vm(VM_ADDRESS);

    /// @notice The Celo registry contract.
    IRegistry private constant celoRegistry = IRegistry(CELO_REGISTRY_ADDRESS);

    /// @notice Stores contracts parsed from broadcast scripts.
    /// @dev Is populated by the `load` function.
    mapping(bytes32 contractName => address contractAddress) private contractAddress;

    /// @notice Stores the content of the `dependencies.json` file, as a string.
    string private dependencies;

    /// @dev keeps a mapping between hash(contractName) and the call data needed to read
    /// the contract address from the GovernanceFactory contract. The mapping
    /// is build in the constructor.
    mapping(bytes32 contractNameHash => bytes getterFn) private govFactoryLookupFn;

    /// @dev To be overriden by implementing contract in order to specify the location
    /// of the `dependencies.json` file. It's defaulted to `./dependencies.json` at
    /// the project root.
    function dependenciesPath() internal virtual returns (string memory);

    /// @dev Reads the dependencies.json file and constructs the call data for looking up
    /// contracts deployed by the GovernanceFactory.
    constructor() {
        string memory root = vm.projectRoot();
        string memory path = string(abi.encodePacked(root, dependenciesPath()));
        dependencies = vm.readFile(path);

        govFactoryLookupFn[keccak256("MentoToken")] = abi.encodeWithSignature("mentoToken()");
        govFactoryLookupFn[keccak256("Emission")] = abi.encodeWithSignature("emission()");
        govFactoryLookupFn[keccak256("GovernanceTimelock")] = abi.encodeWithSignature("governanceTimelock()");
        govFactoryLookupFn[keccak256("MentoGovernor")] = abi.encodeWithSignature("mentoGovernor()");
        govFactoryLookupFn[keccak256("Locking")] = abi.encodeWithSignature("locking()");
        govFactoryLookupFn[keccak256("Airgrab")] = abi.encodeWithSignature("airgrab()");
    }

    /**
     * @notice Shortcut to load a broadcast script by script name and timing suffix.
     * @param script The script name without the `.sol` termination. It should match
     * a folder in `broadcast/`.
     * @param timestamp A timestamp string or `latest`. It should match one of the
     * run-{timestamp}.json files in the broadcast folder for the current chain.
     */
    function load(string memory script, string memory timestamp) internal {
        load(script, timestamp, true);
    }

    /**
     * @notice Load a broadcast script by script name, timing suffix and silence setting.
     * @param script The script name without the `.sol` termination. It should match
     * a folder in `broadcast/`.
     * @param timestamp A timestamp string or `latest`. It should match one of the
     * run-{timestamp}.json files in the broadcast folder for the current chain.
     * @param silent Set eether to log indexed contracts or not.
     */
    function load(string memory script, string memory timestamp, bool silent) internal {
        string memory root = vm.projectRoot();
        string memory path = string(
            abi.encodePacked(
                root, "/broadcast/", script, ".sol/", vm.toString(block.chainid), "/", "run-", timestamp, ".json"
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
            vm.label(contractAddresses[i], contractNames[i]);

            if (!silent) {
                console.log("Loaded contract %s at %s", contractNames[i], contractAddresses[i]);
            }
        }
    }

    /**
     * @notice Lookup a contract in all possible sources and return the address if it's found
     * in only one.
     * @dev Will throw if the contract isn't found anywhere or if there's a conflict and the
     * addresses are different.
     * @param contractName The name of the contract to lookup.
     * @return found The address of the contract.
     */
    function lookup(string memory contractName) public returns (address payable found) {
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
            } else if (results[i] != address(0) && results[i] != found) {
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
        vm.label(found, contractName);
    }

    /**
     * @notice Lookup a contract in contracts recorded from broadcast scripts.
     * @dev Will throw if the contract isn't found.
     * @param contractName The name of the contract to lookup.
     * @return found The address of the contract.
     */
    function lookupDeployed(string memory contractName) public returns (address payable found) {
        found = _lookupDeployed(contractName);
        require(
            found != address(0),
            string(abi.encodePacked("Contracts: ", contractName, " not found in loaded deployment scripts."))
        );
        vm.label(found, contractName);
    }

    /// @dev Internal method that returns address(0) if contract is not found in the source.
    function _lookupDeployed(string memory contractName) private view returns (address payable found) {
        found = payable(contractAddress[keccak256(bytes(contractName))]);
    }

    /**
     * @notice Lookup a contract in Celo Registry.
     * @dev Will throw if the contract isn't found.
     * @param contractName The name of the contract to lookup.
     * @return found The address of the contract.
     */
    function lookupCeloRegistry(string memory contractName) internal returns (address payable found) {
        found = _lookupCeloRegistry(contractName);
        require(
            found != address(0), string(abi.encodePacked("Contracts: ", contractName, " not found in Celo registry."))
        );
        vm.label(found, contractName);
    }

    /// @dev Internal method that returns address(0) if contract is not found in the source.
    function _lookupCeloRegistry(string memory contractName) private view returns (address payable) {
        return payable(celoRegistry.getAddressForString(contractName));
    }

    /**
     * @notice Lookup a contract in the `dependencies.json` file.
     * @dev Will throw if the contract isn't found.
     * @param contractName The name of the contract to lookup.
     * @return found The address of the contract.
     */
    function lookupDependencies(string memory contractName) public returns (address payable found) {
        found = _lookupDependencies(contractName);
        require(
            found != address(0), string(abi.encodePacked("Contracts: ", contractName, " not found in dependencies."))
        );
        vm.label(found, contractName);
    }

    /// @dev Internal method that returns address(0) if contract is not found in the source.
    function _lookupDependencies(string memory contractName) private view returns (address payable) {
        bytes memory contractAddressRaw = dependencies.parseRaw(
            // solhint-disable-next-line quotes
            string(abi.encodePacked('["', vm.toString(block.chainid), '"]', '["', contractName, '"]'))
        );

        if (contractAddressRaw.length != 32) {
            return payable(address(0));
        }
        return abi.decode(contractAddressRaw, (address));
    }

    /**
     * @notice Lookup a contract by querying the GovernanceFactory contract.
     * @dev Will throw if the contract isn't found.
     * @param contractName The name of the contract to lookup.
     * @return found The address of the contract.
     */
    function lookupGovernanceFactory(string memory contractName) public returns (address payable found) {
        found = _lookupGovernanceFactory(contractName);
        require(
            found != address(0),
            string(abi.encodePacked("Contracts: ", contractName, " not found in GovernanceFactory."))
        );
        vm.label(found, contractName);
    }

    /// @dev Internal method that returns address(0) if contract is not found in the source.
    function _lookupGovernanceFactory(string memory contractName) private view returns (address payable found) {
        bytes memory getter = govFactoryLookupFn[keccak256(bytes(contractName))];
        if (getter.length == 0) return payable(address(0));

        address governanceFactory = _lookupDeployed("GovernanceFactory");
        if (governanceFactory == address(0)) {
            governanceFactory = _lookupDependencies("GovernanceFactory");
            if (governanceFactory == address(0)) {
                return payable(address(0));
            }
        }

        (bool ok, bytes memory data) = governanceFactory.staticcall(getter);
        if (ok) {
            found = abi.decode(data, (address));
        }
    }
}
