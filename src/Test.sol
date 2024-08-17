// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// 💬 ABOUT
// Mento's default Test.

// 🧩 MODULES
import {StdAssertions} from "forge-std/StdAssertions.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {CeloChains} from "./CeloChains.sol";
import {CeloPrecompiles} from "./CeloPrecompiles.sol";

// 📦 BOILERPLATE
import {TestBase} from "forge-std/Base.sol";

// ⭐️ TEST
abstract contract Test is
    TestBase,
    StdAssertions,
    CeloChains,
    StdCheats,
    StdInvariant,
    StdUtils,
    CeloPrecompiles
{
    // Note: IS_TEST() must return true.
    bool public IS_TEST = true;
}
