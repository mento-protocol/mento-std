// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8;

import {console} from "forge-std/console.sol";
import {Test} from "src/Test.sol";
import {CeloChains} from "src/CeloChains.sol";

import {CELO_ID, BAKLAVA_ID, ALFAJORES_ID} from "src/Constants.sol";

contract CeloChainsTest is Test {
    function test_getChainCelo() public {
        Chain memory chain = getChain(CELO_ID);
        assertEq(chain.chainAlias, "celo");
        assertEq(chain.name, "Celo");
        assertEq(chain.rpcUrl, "https://forno.celo.org");
        assertEq(chain.chainId, CELO_ID);
    }

    function test_getChainBaklava() public {
        Chain memory chain = getChain(BAKLAVA_ID);
        assertEq(chain.chainAlias, "baklava");
        assertEq(chain.name, "Celo Baklava Testnet");
        assertEq(chain.rpcUrl, "https://baklava-forno.celo-testnet.org");
        assertEq(chain.chainId, BAKLAVA_ID);
    }

    function test_getChainAlfajores() public {
        Chain memory chain = getChain(ALFAJORES_ID);
        assertEq(chain.chainAlias, "alfajores");
        assertEq(chain.name, "Celo Alfajores Testnet");
        assertEq(chain.rpcUrl, "https://alfajores-forno.celo-testnet.org");
        assertEq(chain.chainId, ALFAJORES_ID);
    }

    function test_isCelo() public {
        fork(CELO_ID);
        assertEq(isCelo(), true);
    }

    function test_isBaklava() public {
        fork(BAKLAVA_ID);
        assertEq(isBaklava(), true);
    }

    function test_isAlfajores() public {
        fork(ALFAJORES_ID);
        assertEq(isAlfajores(), true);
    }

    function test_forkCelo() public {
        fork(CELO_ID);
        Chain memory chain = getChain();
        assertEq(chain.chainAlias, "celo");
    }

    function test_forkAlfajores() public {
        fork(ALFAJORES_ID);
        Chain memory chain = getChain();
        assertEq(chain.chainAlias, "alfajores");
    }

    function test_forkBaklava() public {
        fork(ALFAJORES_ID);
        Chain memory chain = getChain();
        assertEq(chain.chainAlias, "alfajores");
    }

    // Should read pk from .env and derive correct address
    function test_deployerAddressCelo() public {
        fork(CELO_ID);
        address deployer = deployerAddress();
        assertEq(deployer, 0x7d8979781389885A30918aa6Ebb5B606c55845f2);
    }

    // Should read pk from .env and derive correct address
    function test_deployerAddressBaklava() public {
        fork(BAKLAVA_ID);
        address deployer = deployerAddress();
        assertEq(deployer, 0x83D8c67ADfFD01522C319476Fd14e85C431f2b63);
    }

    // Should read pk from .env and derive correct address
    function test_deployerAddressAlfajores() public {
        fork(ALFAJORES_ID);
        address deployer = deployerAddress();
        assertEq(deployer, 0xa43e5313e12B84aC737f335A7897668f235768A9);
    }
}
