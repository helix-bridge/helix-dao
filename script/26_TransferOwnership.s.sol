// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Base} from "./common/Base.sol";

interface III {
    function transferOwnership(address newOwner) external;
    function pendingOwner() external view returns (address);
}

contract TransferOwnership26 is Base {
    address nft = 0x3288D1f4bD290D3e9006aA196f1c46D035d789Bf;
    address dao = 0xa8a0b5bEA167E9cDBaAAB52D9EF745Ea3c9fc73D;

    function run() public sphinx {
        III(nft).transferOwnership(dao);
        if (III(nft).pendingOwner() != dao) {
            revert("!transferOwnership");
        }
    }
}
