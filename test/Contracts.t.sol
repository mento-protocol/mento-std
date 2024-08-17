// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8;

import {console} from "forge-std/console.sol";
import {Test} from "src/Test.sol";
import {Contracts} from "src/Contracts.sol";

import {CELO_ID, BAKLAVA_ID, ALFAJORES_ID} from "src/Constants.sol";

contract MockGovernanceFactory is Test {
    address public immutable mentoToken;
    address public immutable emission;
    address public immutable airgrab;
    address public immutable governanceTimelock;
    address public immutable mentoGovernor;
    address public immutable locking;

    constructor(string memory prefix) {
        mentoToken = makeAddr(string(abi.encodePacked(prefix, "/MentoToken")));
        emission = makeAddr(string(abi.encodePacked(prefix, "/Emission")));
        airgrab = makeAddr(string(abi.encodePacked(prefix, "/Airgrab")));
        governanceTimelock = makeAddr(string(abi.encodePacked(prefix, "/GovernanceTimelock")));
        mentoGovernor = makeAddr(string(abi.encodePacked(prefix, "/MentoGovernor")));
        locking = makeAddr(string(abi.encodePacked(prefix, "/Locking")));
    }
}

abstract contract ContractsTest is Test, Contracts {
    function dependenciesPath() internal pure override returns (string memory) {
        return "/test/fixtures/dependencies.json";
    }

    address contract01Expected;
    address contract02Expected;
    address contract03Expected;
    address mentoTokenExpected;
    address emissionExpected;
    address airgrabExpected;
    address governanceTimelockExpected;
    address mentoGovernorExpected;
    address lockingExpected;
    address sortedOraclesExpected;

    function setUp() public virtual {
        load("Fixture0", "latest");
    }

    function test_lookup_fromDeployed() public view {
        address contract01 = lookup("Contract01");
        address contract02 = lookup("Contract02");

        assertEq(contract01, contract01Expected);
        assertEq(contract02, contract02Expected);
    }

    function test_lookupDeployed() public view {
        address contract01 = lookupDeployed("Contract01");
        address contract02 = lookupDeployed("Contract02");

        assertEq(contract01, contract01Expected);
        assertEq(contract02, contract02Expected);
    }

    function test_lookup_fromDependencies() public view {
        address contract03 = lookup("Contract03");
        assertEq(contract03, contract03Expected);
    }

    function test_lookupDependencies() public view {
        address contract03 = lookupDependencies("Contract03");
        assertEq(contract03, contract03Expected);
    }

    function test_lookup_fromCeloRegistry() public view {
        address sortedOracles = lookup("SortedOracles");
        assertEq(sortedOracles, sortedOraclesExpected);
    }

    function test_lookupCeloRegistry() public view {
        address sortedOracles = lookupCeloRegistry("SortedOracles");
        assertEq(sortedOracles, sortedOraclesExpected);
    }

    function test_lookup_fromGovernanceFactory() public view {
        address mentoToken = lookup("MentoToken");
        address emission = lookup("Emission");
        address airgrab = lookup("Airgrab");
        address governanceTimelock = lookup("GovernanceTimelock");
        address mentoGovernor = lookup("MentoGovernor");
        address locking = lookup("Locking");

        assertEq(mentoToken, mentoTokenExpected);
        assertEq(emission, emissionExpected);
        assertEq(airgrab, airgrabExpected);
        assertEq(governanceTimelock, governanceTimelockExpected);
        assertEq(mentoGovernor, mentoGovernorExpected);
        assertEq(locking, lockingExpected);
    }

    function test_lookupGovernanceFactory() public view {
        address mentoToken = lookupGovernanceFactory("MentoToken");
        address emission = lookupGovernanceFactory("Emission");
        address airgrab = lookupGovernanceFactory("Airgrab");
        address governanceTimelock = lookupGovernanceFactory("GovernanceTimelock");
        address mentoGovernor = lookupGovernanceFactory("MentoGovernor");
        address locking = lookupGovernanceFactory("Locking");

        assertEq(mentoToken, mentoTokenExpected);
        assertEq(emission, emissionExpected);
        assertEq(airgrab, airgrabExpected);
        assertEq(governanceTimelock, governanceTimelockExpected);
        assertEq(mentoGovernor, mentoGovernorExpected);
        assertEq(locking, lockingExpected);
    }

    function testFail_lookupWhenNone() public view {
        lookup("UnknownContract");
    }

    function testFail_lookupWhenMultiple() public view {
        lookup("StableToken");
    }
}

contract CeloContractsTest is ContractsTest {
    function setUp() public override {
        fork(CELO_ID);
        contract01Expected = makeAddr("celo/Contract01");
        contract02Expected = makeAddr("celo/Contract02");
        contract03Expected = makeAddr("celo/Contract03");
        mentoTokenExpected = makeAddr("celo/MentoToken");
        emissionExpected = makeAddr("celo/Emission");
        airgrabExpected = makeAddr("celo/Airgrab");
        governanceTimelockExpected = makeAddr("celo/GovernanceTimelock");
        mentoGovernorExpected = makeAddr("celo/MentoGovernor");
        lockingExpected = makeAddr("celo/Locking");
        sortedOraclesExpected = 0xefB84935239dAcdecF7c5bA76d8dE40b077B7b33;
        address mockGovernanceFactory = address(new MockGovernanceFactory("celo"));
        address governanceFactory = lookup("GovernanceFactory");
        vm.etch(governanceFactory, mockGovernanceFactory.code);
        super.setUp();
    }
}

contract BaklavaContractsTest is ContractsTest {
    function setUp() public override {
        fork(BAKLAVA_ID);
        contract01Expected = makeAddr("baklava/Contract01");
        contract02Expected = makeAddr("baklava/Contract02");
        contract03Expected = makeAddr("baklava/Contract03");
        mentoTokenExpected = makeAddr("baklava/MentoToken");
        emissionExpected = makeAddr("baklava/Emission");
        airgrabExpected = makeAddr("baklava/Airgrab");
        governanceTimelockExpected = makeAddr("baklava/GovernanceTimelock");
        mentoGovernorExpected = makeAddr("baklava/MentoGovernor");
        lockingExpected = makeAddr("baklava/Locking");
        sortedOraclesExpected = 0x88A187a876290E9843175027902B9f7f1B092c88;
        address mockGovernanceFactory = address(new MockGovernanceFactory("baklava"));
        address governanceFactory = lookup("GovernanceFactory");
        vm.etch(governanceFactory, mockGovernanceFactory.code);
        super.setUp();
    }
}

contract AlfajoresContractsTest is ContractsTest {
    function setUp() public override {
        fork(ALFAJORES_ID);
        contract01Expected = makeAddr("alfajores/Contract01");
        contract02Expected = makeAddr("alfajores/Contract02");
        contract03Expected = makeAddr("alfajores/Contract03");
        mentoTokenExpected = makeAddr("alfajores/MentoToken");
        emissionExpected = makeAddr("alfajores/Emission");
        airgrabExpected = makeAddr("alfajores/Airgrab");
        governanceTimelockExpected = makeAddr("alfajores/GovernanceTimelock");
        mentoGovernorExpected = makeAddr("alfajores/MentoGovernor");
        lockingExpected = makeAddr("alfajores/Locking");
        sortedOraclesExpected = 0xFdd8bD58115FfBf04e47411c1d228eCC45E93075;
        address mockGovernanceFactory = address(new MockGovernanceFactory("alfajores"));
        address governanceFactory = lookup("GovernanceFactory");
        vm.etch(governanceFactory, mockGovernanceFactory.code);
        super.setUp();
    }
}
