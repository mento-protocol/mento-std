// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8;

import "forge-std/Vm.sol";
import "./Constants.sol";

abstract contract CeloPrecompiles {
    Vm private constant vm = Vm(VM_ADDRESS);

    bytes4 constant TRANSFER_SIG =
        bytes4(keccak256("transfer(address,address,uint256)"));
    bytes4 constant CATCHALL_SIG = bytes4(keccak256("catchAll()"));

    constructor() {
        __CeloPrecompiles_init();
    }

    /// @notice Initialize the Celo precompiles.
    function __CeloPrecompiles_init() internal {
        vm.etch(TRANSFER_PRECOMPILE, proxyTo(TRANSFER_SIG));
        vm.label(TRANSFER_PRECOMPILE, "TRANSFER_PRECOMPILE");
    }

    function transfer(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        if (from != address(0)) {
            require(
                from.balance >= amount,
                "TransferPrecompile: insufficient balance"
            );
            vm.deal(from, from.balance - amount);
        }

        vm.deal(to, to.balance + amount);
        return true;
    }

    /*
     * @dev Constructs the EIP-1167 minimal proxy byecode that would delegate
     * the call from the precompile to this contract.
     * @param sig The signature of the function to delegate to.
     * @return The minimal proxy bytecode.
     */
    function proxyTo(bytes4 selector) internal view returns (bytes memory) {
        address target = address(this);
        bytes memory proxyByteCode;

        // @dev This is not a straightforward implementation of the EIP-1167
        // because the precompile recevies the calldata without any leading function
        // selector. The proxy bytecode is constructed to include the function selector.
        assembly {
            proxyByteCode := mload(0x40) // point proxyByteCode to free memory
            mstore(proxyByteCode, 0x60) // store the length of the bytecode
            let mc := add(proxyByteCode, 0x20) // point mc to the start of the bytecode
            let addrPrefix := shl(0xf8, 0x73) // construct the address prefix
            let addr := shl(0x58, target) // shift the address to the right position
            let sigPrefix := shl(0x50, 0x63) // shift the signature prefix
            let shiftedSig := shl(0x30, shr(0xe0, selector)) // shift the signature
            let suffix := 0x600060043601
            mstore(
                mc,
                or(addrPrefix, or(addr, or(sigPrefix, or(shiftedSig, suffix))))
            ) // constructor the masked first 32 bytes
            mc := add(mc, 0x20) // move mc to the next 32 bytes
            mstore(
                mc,
                0x8260e01b82523660006004840137600080828434885af13d6000816000823e82
            ) // store the rest of the bytecode
            mc := add(mc, 0x20) // move mc to the next 32 bytes
            mstore(
                mc,
                0x60008114604a578282f35b8282fd000000000000000000000000000000000000
            ) // store the rest of the bytecode
            mstore(0x40, add(proxyByteCode, 0x80)) // increment the free memory pointer
        }

        return proxyByteCode;
    }
}
