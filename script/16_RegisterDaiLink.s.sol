// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LnBridgeV3Base} from "./common/LnBridgeV3Base.s.sol";
import {console} from "forge-std/console.sol";

contract RegisterDaiLink16 is LnBridgeV3Base {
    function run() public sphinx {
        initLnBridgeAddress();

        uint256 CHAINID_GNOSIS = chainName2chainId["gnosis"];

        TokenInfo memory dai = getTokenFromConfigure(block.chainid, "dai");
        require(block.chainid == CHAINID_GNOSIS || dai.token != address(0), "dai not configured");
        TokenInfo memory link = getTokenFromConfigure(block.chainid, "link");
        require(block.chainid == CHAINID_GNOSIS || link.token != address(0), "link not configured");
        // check the decimals
        if (block.chainid != CHAINID_GNOSIS) {
            checkTokenAddressOnChain("dai");
            checkTokenAddressOnChain("link");
        }
        string[5] memory allConnectedChains = ["arbitrum", "polygon-pos", "gnosis", "optimistic", "avalanche"];
        for (uint idx = 0; idx < allConnectedChains.length; idx++) {
            string memory remoteChainName = allConnectedChains[idx];
            uint256 remoteChainId = chainName2chainId[remoteChainName];
            if (remoteChainId == block.chainid) {
                continue;
            }

            TokenInfo memory daiRemote = getTokenFromConfigure(remoteChainId, "dai");
            require(remoteChainId == CHAINID_GNOSIS || daiRemote.token != address(0), "remote dai not configured");
            uint256 daiPenalty = 2 * 10 ** dai.decimals;
            registerToken(remoteChainId, dai.symbol, daiRemote.symbol, dai.protocolFee, uint112(daiPenalty));

            if (block.chainid == CHAINID_GNOSIS || remoteChainId == CHAINID_GNOSIS) {
                continue;
            }

            TokenInfo memory linkRemote = getTokenFromConfigure(remoteChainId, "link");
            require(linkRemote.token != address(0), "remote link not configured");
            uint256 linkPenalty = 2 * 10 ** (link.decimals - 1);
            registerToken(remoteChainId, link.symbol, linkRemote.symbol, link.protocolFee, uint112(linkPenalty));
        }
    }
}
