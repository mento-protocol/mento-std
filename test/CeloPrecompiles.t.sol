// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import {console} from "forge-std/console.sol";
import {Test} from "src/Test.sol";

import {TRANSFER_PRECOMPILE, CELO_ID} from "src/Constants.sol";

contract CeloPrecompilesTest is Test {
    function setUp() public {
        vm.setEnv("CELO_RPC_URL", "https://forno.celo.org");
    }

    function test_transferPrecompile() public {
        address from = makeAddr("from");
        address to = makeAddr("to");

        vm.deal(from, 100);
        (bool ok, ) = TRANSFER_PRECOMPILE.call(abi.encode(from, to, 100));

        assertEq(ok, true);
        assertEq(from.balance, 0);
        assertEq(to.balance, 100);
    }

    function test_transferPrecompileAfterFork() public {
        address from = makeAddr("from");
        address to = makeAddr("to");

        vm.deal(from, 100);
        (bool ok, ) = TRANSFER_PRECOMPILE.call(abi.encode(from, to, 100));

        assertEq(ok, true);
        assertEq(from.balance, 0);
        assertEq(to.balance, 100);

        fork(CELO_ID);
        (ok, ) = TRANSFER_PRECOMPILE.call(abi.encode(from, to, 100));
        assertTrue(ok);
        assertEq(from.balance, 0);
        assertEq(to.balance, 0);

        __CeloPrecompiles_init();

        vm.deal(from, 100);
        (ok, ) = TRANSFER_PRECOMPILE.call(abi.encode(from, to, 100));

        assertEq(ok, true);
        assertEq(from.balance, 0);
        assertEq(to.balance, 100);
    }

    function test_transferPrecompileFails() public {
        address from = makeAddr("from");
        address to = makeAddr("to");

        (bool ok, bytes memory data) = TRANSFER_PRECOMPILE.call(
            abi.encode(from, to, 100)
        );
        assertEq(ok, false);
        assertEq(
            data,
            abi.encodeWithSignature(
                "Error(string)",
                "TransferPrecompile: insufficient balance"
            )
        );
    }
}
