// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8;

bytes16 constant HEX_DIGITS = "0123456789abcdef";

/**
 * @notice Converts a `uint256` to its ASCII `string` decimal representation.
 * @dev Borrowed from open-zeppelin
 * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol#L15-L35
 */
function toString(uint256 value) pure returns (string memory) {
    unchecked {
        uint256 length = log10(value) + 1;
        string memory buffer = new string(length);
        uint256 ptr;
        /// @solidity memory-safe-assembly
        assembly {
            ptr := add(buffer, add(32, length))
        }
        while (true) {
            ptr--;
            /// @solidity memory-safe-assembly
            assembly {
                mstore8(ptr, byte(mod(value, 10), HEX_DIGITS))
            }
            value /= 10;
            if (value == 0) break;
        }
        return buffer;
    }
}

/**
 * @notice Return the log in base 10 of a positive value rounded towards zero.
 * Returns 0 if given 0.
 * @dev Borrowed from open-zeppelin
 * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol
 */
function log10(uint256 value) pure returns (uint256) {
    uint256 result = 0;
    unchecked {
        if (value >= 10 ** 64) {
            value /= 10 ** 64;
            result += 64;
        }
        if (value >= 10 ** 32) {
            value /= 10 ** 32;
            result += 32;
        }
        if (value >= 10 ** 16) {
            value /= 10 ** 16;
            result += 16;
        }
        if (value >= 10 ** 8) {
            value /= 10 ** 8;
            result += 8;
        }
        if (value >= 10 ** 4) {
            value /= 10 ** 4;
            result += 4;
        }
        if (value >= 10 ** 2) {
            value /= 10 ** 2;
            result += 2;
        }
        if (value >= 10 ** 1) {
            result += 1;
        }
    }
    return result;
}
