// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LnBridgeV3Base} from "./common/LnBridgeV3Base.s.sol";
import {console} from "forge-std/console.sol";

contract AddMorphArbitrum23 is LnBridgeV3Base {
    function run() public sphinx {
        initLnBridgeAddress();

        uint256 CHAINID_MORPH = chainName2chainId["morph"];
        uint256 CHAINID_ARBITRUM = chainName2chainId["arbitrum"];

        if (block.chainid == CHAINID_MORPH) {
            //messagerAcceptOwnership(MessagerType.MsgportType);
            //acceptOwnership();
        }

        if (block.chainid == CHAINID_ARBITRUM) {
            connectMessager("morph", "msgport");
            connectBridge("morph", "msgport");
            registerToken(CHAINID_MORPH, "eth", "eth", 10000000000000, 1000000000000000);
            registerToken(CHAINID_MORPH, "usdt", "usdt", 100000, 2000000);
        }
    }
}
