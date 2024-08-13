// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LnBridgeV3Base, ILayerZeroMessager} from "./common/LnBridgeV3Base.s.sol";
import {console} from "forge-std/console.sol";

contract RepairArbitrumZircuit19 is LnBridgeV3Base {
    function run() public sphinx {
        initLnBridgeAddress();

        ILayerZeroMessager(0x509354A4ebf98aCC7a65d2264694A65a2938cac9).setRemoteMessager(48900, 110, address(0));
        connectMessager("zircuit", "layerzero");
    }
}
