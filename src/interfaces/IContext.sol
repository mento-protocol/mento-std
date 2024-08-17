// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8;

/**
 * @title IContext
 * @notice Interface that combines methods used to interact with the context of the script
 * can be used when passing the script into library functions.
 */
interface IContext {
    function lookup(string memory contractName) external view returns (address);

    function isCelo() external view returns (bool);

    function isBaklava() external view returns (bool);

    function isAlfajores() external view returns (bool);
}
