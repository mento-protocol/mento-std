// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8;

interface IContracts {
    function lookup(string memory contractName) external view returns (address);
}
