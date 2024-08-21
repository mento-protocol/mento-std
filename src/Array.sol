
// AUTOGENERATED FILE (bin/gen-array-helpers.ts) DON'T MODIFY DIRECTLY
// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8;

function uints(
    uint256 e0
) pure returns (uint256[] memory arr) {
    arr = new uint256[](1);
    arr[0] = e0;

    return arr;
}

function uints(
    uint256 e0,
    uint256 e1
) pure returns (uint256[] memory arr) {
    arr = new uint256[](2);
    arr[0] = e0;
    arr[1] = e1;

    return arr;
}

function uints(
    uint256 e0,
    uint256 e1,
    uint256 e2
) pure returns (uint256[] memory arr) {
    arr = new uint256[](3);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;

    return arr;
}

function uints(
    uint256 e0,
    uint256 e1,
    uint256 e2,
    uint256 e3
) pure returns (uint256[] memory arr) {
    arr = new uint256[](4);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;

    return arr;
}

function uints(
    uint256 e0,
    uint256 e1,
    uint256 e2,
    uint256 e3,
    uint256 e4
) pure returns (uint256[] memory arr) {
    arr = new uint256[](5);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;

    return arr;
}

function uints(
    uint256 e0,
    uint256 e1,
    uint256 e2,
    uint256 e3,
    uint256 e4,
    uint256 e5
) pure returns (uint256[] memory arr) {
    arr = new uint256[](6);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;
    arr[5] = e5;

    return arr;
}

function uints(
    uint256 e0,
    uint256 e1,
    uint256 e2,
    uint256 e3,
    uint256 e4,
    uint256 e5,
    uint256 e6
) pure returns (uint256[] memory arr) {
    arr = new uint256[](7);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;
    arr[5] = e5;
    arr[6] = e6;

    return arr;
}

function uints(
    uint256 e0,
    uint256 e1,
    uint256 e2,
    uint256 e3,
    uint256 e4,
    uint256 e5,
    uint256 e6,
    uint256 e7
) pure returns (uint256[] memory arr) {
    arr = new uint256[](8);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;
    arr[5] = e5;
    arr[6] = e6;
    arr[7] = e7;

    return arr;
}

function contains(uint256[] memory self, uint256 value) pure returns(bool) {
    for (uint256 i = 0; i < self.length; i++) {
        if (self[i] == value) {
            return true;
        }
    }
    return false;
}

function addresses(
    address e0
) pure returns (address[] memory arr) {
    arr = new address[](1);
    arr[0] = e0;

    return arr;
}

function addresses(
    address e0,
    address e1
) pure returns (address[] memory arr) {
    arr = new address[](2);
    arr[0] = e0;
    arr[1] = e1;

    return arr;
}

function addresses(
    address e0,
    address e1,
    address e2
) pure returns (address[] memory arr) {
    arr = new address[](3);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;

    return arr;
}

function addresses(
    address e0,
    address e1,
    address e2,
    address e3
) pure returns (address[] memory arr) {
    arr = new address[](4);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;

    return arr;
}

function addresses(
    address e0,
    address e1,
    address e2,
    address e3,
    address e4
) pure returns (address[] memory arr) {
    arr = new address[](5);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;

    return arr;
}

function addresses(
    address e0,
    address e1,
    address e2,
    address e3,
    address e4,
    address e5
) pure returns (address[] memory arr) {
    arr = new address[](6);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;
    arr[5] = e5;

    return arr;
}

function addresses(
    address e0,
    address e1,
    address e2,
    address e3,
    address e4,
    address e5,
    address e6
) pure returns (address[] memory arr) {
    arr = new address[](7);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;
    arr[5] = e5;
    arr[6] = e6;

    return arr;
}

function addresses(
    address e0,
    address e1,
    address e2,
    address e3,
    address e4,
    address e5,
    address e6,
    address e7
) pure returns (address[] memory arr) {
    arr = new address[](8);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;
    arr[5] = e5;
    arr[6] = e6;
    arr[7] = e7;

    return arr;
}

function contains(address[] memory self, address value) pure returns(bool) {
    for (uint256 i = 0; i < self.length; i++) {
        if (self[i] == value) {
            return true;
        }
    }
    return false;
}

function bytes4s(
    bytes4 e0
) pure returns (bytes4[] memory arr) {
    arr = new bytes4[](1);
    arr[0] = e0;

    return arr;
}

function bytes4s(
    bytes4 e0,
    bytes4 e1
) pure returns (bytes4[] memory arr) {
    arr = new bytes4[](2);
    arr[0] = e0;
    arr[1] = e1;

    return arr;
}

function bytes4s(
    bytes4 e0,
    bytes4 e1,
    bytes4 e2
) pure returns (bytes4[] memory arr) {
    arr = new bytes4[](3);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;

    return arr;
}

function bytes4s(
    bytes4 e0,
    bytes4 e1,
    bytes4 e2,
    bytes4 e3
) pure returns (bytes4[] memory arr) {
    arr = new bytes4[](4);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;

    return arr;
}

function bytes4s(
    bytes4 e0,
    bytes4 e1,
    bytes4 e2,
    bytes4 e3,
    bytes4 e4
) pure returns (bytes4[] memory arr) {
    arr = new bytes4[](5);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;

    return arr;
}

function bytes4s(
    bytes4 e0,
    bytes4 e1,
    bytes4 e2,
    bytes4 e3,
    bytes4 e4,
    bytes4 e5
) pure returns (bytes4[] memory arr) {
    arr = new bytes4[](6);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;
    arr[5] = e5;

    return arr;
}

function bytes4s(
    bytes4 e0,
    bytes4 e1,
    bytes4 e2,
    bytes4 e3,
    bytes4 e4,
    bytes4 e5,
    bytes4 e6
) pure returns (bytes4[] memory arr) {
    arr = new bytes4[](7);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;
    arr[5] = e5;
    arr[6] = e6;

    return arr;
}

function bytes4s(
    bytes4 e0,
    bytes4 e1,
    bytes4 e2,
    bytes4 e3,
    bytes4 e4,
    bytes4 e5,
    bytes4 e6,
    bytes4 e7
) pure returns (bytes4[] memory arr) {
    arr = new bytes4[](8);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;
    arr[5] = e5;
    arr[6] = e6;
    arr[7] = e7;

    return arr;
}

function contains(bytes4[] memory self, bytes4 value) pure returns(bool) {
    for (uint256 i = 0; i < self.length; i++) {
        if (self[i] == value) {
            return true;
        }
    }
    return false;
}

function bytes32s(
    bytes32 e0
) pure returns (bytes32[] memory arr) {
    arr = new bytes32[](1);
    arr[0] = e0;

    return arr;
}

function bytes32s(
    bytes32 e0,
    bytes32 e1
) pure returns (bytes32[] memory arr) {
    arr = new bytes32[](2);
    arr[0] = e0;
    arr[1] = e1;

    return arr;
}

function bytes32s(
    bytes32 e0,
    bytes32 e1,
    bytes32 e2
) pure returns (bytes32[] memory arr) {
    arr = new bytes32[](3);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;

    return arr;
}

function bytes32s(
    bytes32 e0,
    bytes32 e1,
    bytes32 e2,
    bytes32 e3
) pure returns (bytes32[] memory arr) {
    arr = new bytes32[](4);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;

    return arr;
}

function bytes32s(
    bytes32 e0,
    bytes32 e1,
    bytes32 e2,
    bytes32 e3,
    bytes32 e4
) pure returns (bytes32[] memory arr) {
    arr = new bytes32[](5);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;

    return arr;
}

function bytes32s(
    bytes32 e0,
    bytes32 e1,
    bytes32 e2,
    bytes32 e3,
    bytes32 e4,
    bytes32 e5
) pure returns (bytes32[] memory arr) {
    arr = new bytes32[](6);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;
    arr[5] = e5;

    return arr;
}

function bytes32s(
    bytes32 e0,
    bytes32 e1,
    bytes32 e2,
    bytes32 e3,
    bytes32 e4,
    bytes32 e5,
    bytes32 e6
) pure returns (bytes32[] memory arr) {
    arr = new bytes32[](7);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;
    arr[5] = e5;
    arr[6] = e6;

    return arr;
}

function bytes32s(
    bytes32 e0,
    bytes32 e1,
    bytes32 e2,
    bytes32 e3,
    bytes32 e4,
    bytes32 e5,
    bytes32 e6,
    bytes32 e7
) pure returns (bytes32[] memory arr) {
    arr = new bytes32[](8);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;
    arr[5] = e5;
    arr[6] = e6;
    arr[7] = e7;

    return arr;
}

function contains(bytes32[] memory self, bytes32 value) pure returns(bool) {
    for (uint256 i = 0; i < self.length; i++) {
        if (self[i] == value) {
            return true;
        }
    }
    return false;
}

function bytesList(
    bytes memory e0
) pure returns (bytes[] memory arr) {
    arr = new bytes[](1);
    arr[0] = e0;

    return arr;
}

function bytesList(
    bytes memory e0,
    bytes memory e1
) pure returns (bytes[] memory arr) {
    arr = new bytes[](2);
    arr[0] = e0;
    arr[1] = e1;

    return arr;
}

function bytesList(
    bytes memory e0,
    bytes memory e1,
    bytes memory e2
) pure returns (bytes[] memory arr) {
    arr = new bytes[](3);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;

    return arr;
}

function bytesList(
    bytes memory e0,
    bytes memory e1,
    bytes memory e2,
    bytes memory e3
) pure returns (bytes[] memory arr) {
    arr = new bytes[](4);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;

    return arr;
}

function bytesList(
    bytes memory e0,
    bytes memory e1,
    bytes memory e2,
    bytes memory e3,
    bytes memory e4
) pure returns (bytes[] memory arr) {
    arr = new bytes[](5);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;

    return arr;
}

function bytesList(
    bytes memory e0,
    bytes memory e1,
    bytes memory e2,
    bytes memory e3,
    bytes memory e4,
    bytes memory e5
) pure returns (bytes[] memory arr) {
    arr = new bytes[](6);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;
    arr[5] = e5;

    return arr;
}

function bytesList(
    bytes memory e0,
    bytes memory e1,
    bytes memory e2,
    bytes memory e3,
    bytes memory e4,
    bytes memory e5,
    bytes memory e6
) pure returns (bytes[] memory arr) {
    arr = new bytes[](7);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;
    arr[5] = e5;
    arr[6] = e6;

    return arr;
}

function bytesList(
    bytes memory e0,
    bytes memory e1,
    bytes memory e2,
    bytes memory e3,
    bytes memory e4,
    bytes memory e5,
    bytes memory e6,
    bytes memory e7
) pure returns (bytes[] memory arr) {
    arr = new bytes[](8);
    arr[0] = e0;
    arr[1] = e1;
    arr[2] = e2;
    arr[3] = e3;
    arr[4] = e4;
    arr[5] = e5;
    arr[6] = e6;
    arr[7] = e7;

    return arr;
}
