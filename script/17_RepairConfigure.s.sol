// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LnBridgeV3Base} from "./common/LnBridgeV3Base.s.sol";
import {console} from "forge-std/console.sol";

contract RepairConfigure17 is LnBridgeV3Base {
    function run() public sphinx {
        initLnBridgeAddress();

        uint256 CHAINID_POLYGON = chainName2chainId["polygon-pos"];
        uint256 CHAINID_BLAST = chainName2chainId["blast"];
        uint256 CHAINID_DARWINIA = chainName2chainId["darwinia"];
        uint256 CHAINID_MOONBEAM = chainName2chainId["moonbeam"];

        // messager accept ownership
        if (block.chainid == CHAINID_POLYGON) {
            messagerAcceptOwnership(MessagerType.MsgportType);
        }
        if (block.chainid == CHAINID_BLAST) {
            messagerAcceptOwnership(MessagerType.LayerzeroType);
        }

        // connect moonbeam<>darwinia using msgport
        if (block.chainid == CHAINID_MOONBEAM) {
            // accept messager ownership
            messagerAcceptOwnership(MessagerType.MsgportType);
            // set send/recv service
            connectBridge("darwinia", "msgport");
        }
        // messager darwinia -> moonbeam
        if (block.chainid == CHAINID_DARWINIA) {
            connectMessager("moonbeam", "msgport");
            connectBridge("moonbeam", "msgport");
        }
    }
}
