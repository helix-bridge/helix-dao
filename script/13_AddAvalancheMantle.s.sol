// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LnBridgeV3Base} from "./common/LnBridgeV3Base.s.sol";
import {safeconsole} from "forge-std/safeconsole.sol";

contract AddAvalancheMantle13 is LnBridgeV3Base {
    function run() public sphinx {
        initLnBridgeAddress();

        uint256 CHAINID_AVALANCHE = chainName2chainId["avalanche"];
        if (block.chainid == CHAINID_AVALANCHE) {
            messagerAcceptOwnership(MessagerType.LayerzeroType);
            acceptOwnership();
        }

        TokenInfo memory localTokenInfo = getTokenFromConfigure(block.chainid, "usdc");
        require(localTokenInfo.token != address(0), "local token not configured");
        // check the decimals
        checkTokenAddressOnChain("usdc");
        string[9] memory allConnectedChains = ["arbitrum", "scroll", "polygon-pos", "bsc", "base", "gnosis", "optimistic", "avalanche", "mantle"];
        for (uint idx = 0; idx < allConnectedChains.length; idx++) {
            string memory remoteChainName = allConnectedChains[idx];
            connectMessager(remoteChainName, "layerzero");
            connectBridge(remoteChainName, "layerzero");
            uint256 remoteChainId = chainName2chainId[remoteChainName];
            if (remoteChainId == block.chainid) {
                continue;
            }

            TokenInfo memory remoteTokenInfo = getTokenFromConfigure(remoteChainId, "usdc");
            require(remoteTokenInfo.token != address(0), "remote token not configured");
            uint256 penalty = 2 * 10 ** localTokenInfo.decimals;
            registerToken(remoteChainId, localTokenInfo.symbol, remoteTokenInfo.symbol, localTokenInfo.protocolFee, uint112(penalty));
        }
    }
}
