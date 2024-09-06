// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Base} from "./common/Base.sol";
import {safeconsole} from "forge-std/safeconsole.sol";

interface IMsgportMessager {
    function setRemoteMessager(uint256 _appRemoteChainId, uint256 _msgportRemoteChainId, address _remoteMessager)
        external;

    function setWhiteList(address _caller, bool _enable) external;
}

contract XTokenMessagerConnectTron21 is Base {
    IMsgportMessager messager = IMsgportMessager(0x65Be094765731F394bc6d9DF53bDF3376F1Fc8B0);
	address backing = 0x7defE0f6105a9498376B72FFfaedf102A2f63cD5;

    function run() public sphinx {
        messager.setRemoteMessager(728126428, 728126428, 0x13Fd60a93feD8141875378Ba57500c5E554C93F2);
		messager.setWhiteList(backing, true);
    }
}
