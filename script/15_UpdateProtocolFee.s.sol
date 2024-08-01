// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LnBridgeV3Base} from "./common/LnBridgeV3Base.s.sol";
import {safeconsole} from "forge-std/safeconsole.sol";

contract UpdateProtocolFee15 is LnBridgeV3Base {
    function run() public sphinx {
        initLnBridgeAddress();

        uint256 CHAINID_POLYGON = chainName2chainId["polygon-pos"];
        uint256 CHAINID_BSC = chainName2chainId["bsc"];
        uint256 CHAINID_AVALANCHE = chainName2chainId["avalanche"];

        uint256 CHAINID_ARBITRUM = chainName2chainId["arbitrum"];
        uint256 CHAINID_SCROLL = chainName2chainId["scroll"];
        uint256 CHAINID_BASE = chainName2chainId["base"];
        uint256 CHAINID_OPTIMISTIC = chainName2chainId["optimistic"];

        uint256 chainId = block.chainid;

        bool isEthNative = chainId == CHAINID_ARBITRUM || chainId == CHAINID_SCROLL || chainId == CHAINID_BASE || chainId == CHAINID_OPTIMISTIC;
        bool hasUsdtBtc = chainId == CHAINID_ARBITRUM || chainId == CHAINID_BSC || chainId == CHAINID_OPTIMISTIC || chainId == CHAINID_POLYGON || chainId == CHAINID_AVALANCHE;

        string[5] memory usdtAndWbtcChains = ["arbitrum", "polygon-pos", "bsc", "optimistic", "avalanche"];
        string[9] memory allChains = ["arbitrum", "scroll", "polygon-pos", "bsc", "base", "gnosis", "optimistic", "avalanche", "mantle"];


        TokenInfo memory usdc = getTokenFromConfigure(block.chainid, "usdc");
        require(usdc.token != address(0), "local token not configured");
        TokenInfo memory usdt = getTokenFromConfigure(block.chainid, "usdt");
        require(usdt.token != address(0), "local token not configured");
        TokenInfo memory wbtc = getTokenFromConfigure(block.chainid, "wbtc");
        require(wbtc.token != address(0), "local token not configured");

        for (uint idx = 0; idx < allChains.length; idx++) {
            string memory remoteChainName = allChains[idx];
            uint256 remoteChainId = chainName2chainId[remoteChainName];
            if (remoteChainId == block.chainid) {
                continue;
            }
            TokenInfo memory usdcRemote = getTokenFromConfigure(remoteChainId, "usdc");
            require(usdcRemote.token != address(0), "remote usdt not configured");
            uint256 usdcPenalty = 2 * 10 ** usdc.decimals;
            updateToken(remoteChainId, usdc.symbol, usdcRemote.symbol, usdc.protocolFee, uint112(usdcPenalty));
            if (isEthNative) {
                updateToken(remoteChainId, "eth", "eth", 10000000000000, 1000000000000000);
            }
        }

        if (!hasUsdtBtc) {
            return;
        }
        for (uint idx = 0; idx < usdtAndWbtcChains.length; idx++) {
            string memory remoteChainName = usdtAndWbtcChains[idx];
            uint256 remoteChainId = chainName2chainId[remoteChainName];
            if (remoteChainId == block.chainid) {
                continue;
            }

            TokenInfo memory usdtRemote = getTokenFromConfigure(remoteChainId, "usdt");
            require(usdtRemote.token != address(0), "remote usdt not configured");
            uint256 usdtPenalty = 2 * 10 ** usdt.decimals;
            updateToken(remoteChainId, usdt.symbol, usdtRemote.symbol, usdt.protocolFee, uint112(usdtPenalty));

            TokenInfo memory wbtcRemote = getTokenFromConfigure(remoteChainId, "wbtc");
            require(wbtcRemote.token != address(0), "remote wbtc not configured");
            uint256 wbtcPenalty = 2 * 10 ** (wbtc.decimals - 5);
            updateToken(remoteChainId, wbtc.symbol, wbtcRemote.symbol, wbtc.protocolFee, uint112(wbtcPenalty));
        }
    }
}
