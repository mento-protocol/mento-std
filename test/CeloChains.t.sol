// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8;

import {console} from "forge-std/console.sol";
import {Test} from "src/Test.sol";
import {CeloChains} from "src/CeloChains.sol";

import {CELO_ID, BAKLAVA_ID, ALFAJORES_ID} from "src/Constants.sol";

contract CeloChainsTest is Test {
    address celoDeployerAddress;
    address baklavaDeployerAddress;
    address alfajoresDeployerAddress;

    constructor() Test() {
        vm.setEnv("CELO_RPC_URL", "https://forno.celo.org");
        vm.setEnv(
            "ALFAJORES_RPC_URL",
            "https://alfajores-forno.celo-testnet.org"
        );
        vm.setEnv("BAKLAVA_RPC_URL", "https://baklava-forno.celo-testnet.org");

        uint256 celoDeployerPk;
        uint256 baklavaDeployerPk;
        uint256 alfajoresDeployerPk;

        (celoDeployerAddress, celoDeployerPk) = makeAddrAndKey("celoDeployer");
        (alfajoresDeployerAddress, alfajoresDeployerPk) = makeAddrAndKey(
            "alfajoresDeployer"
        );
        (baklavaDeployerAddress, baklavaDeployerPk) = makeAddrAndKey(
            "baklavaDeployer"
        );

        vm.setEnv("celo_DEPLOYER_PK", vm.toString(celoDeployerPk));
        vm.setEnv("alfajores_DEPLOYER_PK", vm.toString(alfajoresDeployerPk));
        vm.setEnv("baklava_DEPLOYER_PK", vm.toString(baklavaDeployerPk));
    }

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

    function test_forkCeloAtBlock() public {
        fork(CELO_ID);
        uint256 blockNumber = block.number - 100;
        fork(CELO_ID, blockNumber);
        Chain memory chain = getChain();
        assertEq(block.number, blockNumber);
        assertEq(chain.chainAlias, "celo");
    }

    function test_forkAlfajoresAtBlock() public {
        fork(ALFAJORES_ID);
        uint256 blockNumber = block.number - 100;
        fork(ALFAJORES_ID, blockNumber);
        Chain memory chain = getChain();
        assertEq(block.number, blockNumber);
        assertEq(chain.chainAlias, "alfajores");
    }

    function test_forkBaklavaAtBlock() public {
        fork(BAKLAVA_ID);
        uint256 blockNumber = block.number - 100;
        fork(BAKLAVA_ID, blockNumber);
        Chain memory chain = getChain();
        assertEq(block.number, blockNumber);
        assertEq(chain.chainAlias, "baklava");
    }

    // Should read pk from .env and derive correct address
    function test_deployerAddressCelo() public {
        fork(CELO_ID);
        address deployer = deployerAddress();
        assertEq(deployer, celoDeployerAddress);
    }

    // Should read pk from .env and derive correct address
    function test_deployerAddressBaklava() public {
        fork(BAKLAVA_ID);
        address deployer = deployerAddress();
        assertEq(deployer, baklavaDeployerAddress);
    }

    // Should read pk from .env and derive correct address
    function test_deployerAddressAlfajores() public {
        fork(ALFAJORES_ID);
        address deployer = deployerAddress();
        assertEq(deployer, alfajoresDeployerAddress);
    }
}
