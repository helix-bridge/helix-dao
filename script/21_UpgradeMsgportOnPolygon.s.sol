// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LnBridgeV3Base, ILayerZeroMessager} from "./common/LnBridgeV3Base.s.sol";
import {console} from "forge-std/console.sol";

contract UpgradeMsgportOnPolygon21 is LnBridgeV3Base {
    function run() public sphinx {
        initLnBridgeAddress();

        messagerUpdateLowMessager("msgport", 0x2cd1867Fb8016f93710B6386f7f9F1D540A60812);
    }
}
