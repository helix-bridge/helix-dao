// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LnBridgeV3Base} from "./common/LnBridgeV3Base.s.sol";
import {safeconsole} from "forge-std/safeconsole.sol";

contract RegisterUsdtBtc14 is LnBridgeV3Base {
    function run() public sphinx {
        initLnBridgeAddress();

        TokenInfo memory usdt = getTokenFromConfigure(block.chainid, "usdt");
        require(usdt.token != address(0), "usdt not configured");
        TokenInfo memory wbtc = getTokenFromConfigure(block.chainid, "wbtc");
        require(wbtc.token != address(0), "wbtc not configured");
        // check the decimals
        checkTokenAddressOnChain("usdt");
        checkTokenAddressOnChain("wbtc");
        string[5] memory allConnectedChains = ["arbitrum", "polygon-pos", "bsc", "optimistic", "avalanche"];
        for (uint idx = 0; idx < allConnectedChains.length; idx++) {
            string memory remoteChainName = allConnectedChains[idx];
            uint256 remoteChainId = chainName2chainId[remoteChainName];
            if (remoteChainId == block.chainid) {
                continue;
            }

            TokenInfo memory usdtRemote = getTokenFromConfigure(remoteChainId, "usdt");
            require(usdtRemote.token != address(0), "remote usdt not configured");
            uint256 usdtPenalty = 2 * 10 ** usdt.decimals;
            registerToken(remoteChainId, usdt.symbol, usdtRemote.symbol, usdt.protocolFee, uint112(usdtPenalty));

            TokenInfo memory wbtcRemote = getTokenFromConfigure(remoteChainId, "wbtc");
            require(wbtcRemote.token != address(0), "remote wbtc not configured");
            uint256 wbtcPenalty = 2 * 10 ** (wbtc.decimals - 5);
            registerToken(remoteChainId, wbtc.symbol, wbtcRemote.symbol, wbtc.protocolFee, uint112(wbtcPenalty));
        }
    }
}
