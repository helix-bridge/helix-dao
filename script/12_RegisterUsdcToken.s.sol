// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LnBridgeV3Base} from "./common/LnBridgeV3Base.s.sol";
import {safeconsole} from "forge-std/safeconsole.sol";

contract RegisterUsdcToken12 is LnBridgeV3Base {
    function notEthGasChain(uint256 chainId) view internal returns(bool) {
        uint256 CHAINID_POLYGON = chainName2chainId["polygon-pos"];
        uint256 CHAINID_BSC = chainName2chainId["bsc"];
        uint256 CHAINID_GNOSIS = chainName2chainId["gnosis"];
        return chainId == CHAINID_POLYGON || chainId == CHAINID_BSC || chainId == CHAINID_GNOSIS;
    }
    function run() public sphinx {
        initLnBridgeAddress();

        TokenInfo memory localTokenInfo = getTokenFromConfigure(block.chainid, "usdc");
        require(localTokenInfo.token != address(0), "local token not configured");
        // check the decimals
        checkTokenAddressOnChain("usdc");
        string[7] memory allConnectedChains = ["arbitrum", "scroll", "polygon-pos", "bsc", "base", "gnosis", "optimistic"];
        for (uint idx = 0; idx < allConnectedChains.length; idx++) {
            string memory remoteChainName = allConnectedChains[idx];
            uint256 remoteChainId = chainName2chainId[remoteChainName];
            if (remoteChainId == block.chainid) {
                continue;
            }

            TokenInfo memory remoteTokenInfo = getTokenFromConfigure(remoteChainId, "usdc");
            require(remoteTokenInfo.token != address(0), "remote token not configured");
            uint256 penalty = 2 * 10 ** localTokenInfo.decimals;
            registerToken(remoteChainId, localTokenInfo.symbol, remoteTokenInfo.symbol, localTokenInfo.protocolFee, uint112(penalty));

            // register eth
            if (notEthGasChain(block.chainid) || notEthGasChain(remoteChainId)) {
                continue;
            }
            registerToken(remoteChainId, "eth", "eth", 10000000000000, 1000000000000000);
        }
    }
}
