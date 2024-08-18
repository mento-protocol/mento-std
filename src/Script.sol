// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8;

// 💬 ABOUT
// Mento's default Script, extension of Forge's

// 🧩 MODULES
import {StdCheatsSafe} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {CeloChains} from "./CeloChains.sol";
import {ContractsLookup} from "./ContractsLookup.sol";

// 📦 BOILERPLATE
import {ScriptBase} from "forge-std/Base.sol";

// ⭐️ SCRIPT
abstract contract Script is ScriptBase, CeloChains, ContractsLookup, StdCheatsSafe, StdUtils {
    // Note: IS_SCRIPT() must return true.
    bool public IS_SCRIPT = true;

    /// @notice Defaults dependenciesPath to "<project root>/dependencies.json",
    /// can be overriden by inheriting contracts.
    function dependenciesPath() internal pure virtual override returns (string memory) {
        return "/dependencies.json";
    }
}
