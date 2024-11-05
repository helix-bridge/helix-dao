// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LnBridgeV3Base} from "./common/LnBridgeV3Base.s.sol";
import {safeconsole} from "forge-std/safeconsole.sol";

contract UpdateProtocolFee24 is LnBridgeV3Base {
    function run() public sphinx {
        initLnBridgeAddress();

        uint256 CHAINID_POLYGON = chainName2chainId["polygon-pos"];
        uint256 CHAINID_BSC = chainName2chainId["bsc"];
        uint256 CHAINID_AVALANCHE = chainName2chainId["avalanche"];

        uint256 CHAINID_ARBITRUM = chainName2chainId["arbitrum"];
        uint256 CHAINID_OPTIMISTIC = chainName2chainId["optimistic"];
        uint256 CHAINID_SCROLL = chainName2chainId["scroll"];
        //uint256 CHAINID_BASE = chainName2chainId["base"];

        uint256 chainId = block.chainid;

        bool hasUsdt = chainId == CHAINID_ARBITRUM || chainId == CHAINID_BSC || chainId == CHAINID_OPTIMISTIC || chainId == CHAINID_POLYGON || chainId == CHAINID_AVALANCHE || chainId == CHAINID_SCROLL;
        //bool hasEth = chainId == CHAINID_ARBITRUM || chainId == CHAINID_OPTIMISTIC || chainId == CHAINID_SCROLL || chainId == CHAINID_BASE;

        //string[4] memory ethChains = ["arbitrum", "optimistic", "scroll", "base"];
        string[6] memory usdtChains = ["arbitrum", "polygon-pos", "bsc", "optimistic", "avalanche", "scroll"];
        string[9] memory allChains = ["arbitrum", "scroll", "polygon-pos", "bsc", "base", "gnosis", "optimistic", "avalanche", "mantle"];


        TokenInfo memory usdc = getTokenFromConfigure(block.chainid, "usdc");
        require(usdc.token != address(0), "usdc token not configured");

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
        }

        if (hasUsdt) {
            TokenInfo memory usdt = getTokenFromConfigure(block.chainid, "usdt");
            require(usdt.token != address(0), "usdt token not configured");
            for (uint idx = 0; idx < usdtChains.length; idx++) {
                string memory remoteChainName = usdtChains[idx];
                uint256 remoteChainId = chainName2chainId[remoteChainName];
                if (remoteChainId == block.chainid) {
                    continue;
                }

                TokenInfo memory usdtRemote = getTokenFromConfigure(remoteChainId, "usdt");
                require(usdtRemote.token != address(0), "remote usdt not configured");
                uint256 usdtPenalty = 2 * 10 ** usdt.decimals;

                if ((CHAINID_SCROLL == chainId && remoteChainId == CHAINID_AVALANCHE) || (CHAINID_AVALANCHE == chainId && remoteChainId == CHAINID_SCROLL)) {
                    registerToken(remoteChainId, usdt.symbol, usdtRemote.symbol, usdt.protocolFee, uint112(usdtPenalty));
                } else {
                    updateToken(remoteChainId, usdt.symbol, usdtRemote.symbol, usdt.protocolFee, uint112(usdtPenalty));
                }
            }
        }

        /*
        if (hasEth) {
            TokenInfo memory eth = getTokenFromConfigure(block.chainid, "eth");
            for (uint idx = 0; idx < ethChains.length; idx++) {
                string memory remoteChainName = ethChains[idx];
                uint256 remoteChainId = chainName2chainId[remoteChainName];
                if (remoteChainId == block.chainid) {
                    continue;
                }

                TokenInfo memory ethRemote = getTokenFromConfigure(remoteChainId, "eth");
                uint256 ethPenalty = 2 * 10 ** eth.decimals;
                updateToken(remoteChainId, eth.symbol, ethRemote.symbol, eth.protocolFee, uint112(ethPenalty));
            }
        }
        */
    }
}

