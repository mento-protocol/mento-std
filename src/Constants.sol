// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8;

address constant VM_ADDRESS = address(uint160(uint256(keccak256("hevm cheat code"))));

address constant CELO_REGISTRY_ADDRESS = 0x000000000000000000000000000000000000ce10;

uint256 constant CELO_ID = 42220;
uint256 constant BAKLAVA_ID = 62320;
uint256 constant ALFAJORES_ID = 44787;

address constant TRANSFER_PRECOMPILE = address(0xff - 2);
