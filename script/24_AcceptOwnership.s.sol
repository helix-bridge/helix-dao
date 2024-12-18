// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Base} from "./common/Base.sol";

interface III {
    function dao() external view returns (address);
    function pendingDao() external view returns (address);
    function acceptOwnership() external;
}

contract AcceptOwnership24 is Base {
    address backing = 0xa64D1c284280b22f921E7B2A55040C7bbfD4d9d0;
    address issuing = 0xf6372ab2d35B32156A19F2d2F23FA6dDeFBE58bd;

    function run() public sphinx {
        address dao = safeAddress();
        if (dao == III(backing).pendingDao()) {
            III(backing).acceptOwnership();
        }
        if (dao == III(issuing).pendingDao()) {
            III(issuing).acceptOwnership();
        }
        require(III(backing).dao() == dao, "!backing");
        require(III(issuing).dao() == dao, "!issuing");
    }
}
