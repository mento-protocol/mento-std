// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import {console} from "forge-std/console.sol";
import {Test} from "src/Test.sol";
import {Contracts} from "src/Contracts.sol";

import {TRANSFER_PRECOMPILE} from "src/Constants.sol";

contract CeloPrecompilesTest is Test {
    function test_transferPrecompile() public {
        address from = address(0x1);
        address to = address(0x2);

        vm.deal(from, 100);
        (bool ok, ) = TRANSFER_PRECOMPILE.call(abi.encode(from, to, 100));

        assertEq(ok, true);
        assertEq(from.balance, 0);
        assertEq(to.balance, 100);
    }

    function test_transferPrecompileFails() public {
        address from = address(0x1);
        address to = address(0x2);

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
