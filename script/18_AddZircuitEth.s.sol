// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LnBridgeV3Base} from "./common/LnBridgeV3Base.s.sol";
import {console} from "forge-std/console.sol";

contract AddZircuitEth18 is LnBridgeV3Base {
    function run() public sphinx {
        initLnBridgeAddress();

        uint256 CHAINID_ZIRCUIT = chainName2chainId["zircuit"];
        uint256 CHAINID_ARBITRUM = chainName2chainId["arbitrum"];

        // messager accept ownership
        if (block.chainid == CHAINID_ZIRCUIT) {
            messagerAcceptOwnership(MessagerType.LayerzeroType);
            acceptOwnership();
            // register ETH
            registerToken(CHAINID_ARBITRUM, "eth", "eth", 10000000000000, 1000000000000000);
        }

        if (block.chainid == CHAINID_ARBITRUM) {
            connectMessager("zircuit", "layerzero");
            connectBridge("zircuit", "layerzero");
            registerToken(CHAINID_ZIRCUIT, "eth", "eth", 10000000000000, 1000000000000000);
        }
    }
}
