// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Base} from "./common/Base.sol";

interface III {
    function setReceiveService(uint256 _remoteChainId, address _remoteBridge, address _service) external;
}

contract SunsetArbitrumPolygon is Base {
    address private constant sunsetMessagerServiceArbitrum = 0x6035Eb7783d7Aab8d0a57a7b154f5DD5D5477Ff2;
    address private constant sunsetMessagerServicePolygon = 0x33C9916a43507aa0a89a3e889522f840aa1245fE;
	address private constant lnBridge = 0xbA5D580B18b6436411562981e02c8A9aA1776D10;

    function run() public sphinx {
        uint256 chainId = block.chainid;
		if (chainId == 42161) {
			// III(backing).withdraw(xring, receiver, III(xring).balanceOf(backing));
            III(lnBridge).setReceiveService(137, address(0), sunsetMessagerServiceArbitrum);
		}
        if (chainId == 137) {
            III(lnBridge).setReceiveService(42161, address(0), sunsetMessagerServicePolygon);
        }
    }
}
