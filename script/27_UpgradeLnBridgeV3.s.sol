// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LnBridgeV3Base} from "./common/LnBridgeV3Base.s.sol";
import {HelixLnBridgeV3} from "@helix/contracts/helix-contract/contracts/ln/lnv3/HelixLnBridgeV3.sol";

interface III {
    function withdrawNativeToken(address payable _to, uint256 _amount) external;
}

interface IProxyAdmin {
    function upgrade(address, address) external;
}

contract UpgradeLnBridge27 is LnBridgeV3Base {
    address private constant oldImpl = 0xbBad04cBF890e66B7c9a5e7FD6A7ff110E7d35A9;
    address private constant newImpl = 0x57Ab12525911740B9848B2F117e6EEc83042D409;
    address payable private constant receiver = payable(0x3B9E571AdeCB0c277486036D6097E9C2CCcfa9d9);
    bytes32 private constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
    bytes32 private constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function run() public sphinx {
        uint256 chainId = block.chainid;
        initLnBridgeAddress();
        address bridge = bridgerInfos[chainId].bridger;

        require(newImpl.code.length > 0, "!deploy");
        address admin = getAdminAddress(bridge);
        IProxyAdmin(admin).upgrade(bridge, newImpl);
        require(getImplementationAddress(bridge) == newImpl, "!upgrade");
        III(bridge).withdrawNativeToken(receiver, address(bridge).balance);
    }

    function getAdminAddress(address proxy) internal view returns (address) {
        bytes32 adminSlot = vmSafe.load(proxy, ADMIN_SLOT);
        return address(uint160(uint256(adminSlot)));
    }

    function getImplementationAddress(address proxy) internal view returns (address) {
        bytes32 implSlot = vmSafe.load(proxy, IMPLEMENTATION_SLOT);
        return address(uint160(uint256(implSlot)));
    }
}
