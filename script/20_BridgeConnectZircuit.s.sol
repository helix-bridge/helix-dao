// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LnBridgeV3Base, ILayerZeroMessager} from "./common/LnBridgeV3Base.s.sol";
import {console} from "forge-std/console.sol";

contract BridgeConnectZircuit20 is LnBridgeV3Base {
    function run() public sphinx {
        initLnBridgeAddress();

        connectBridge("zircuit", "layerzero");
    }
}
