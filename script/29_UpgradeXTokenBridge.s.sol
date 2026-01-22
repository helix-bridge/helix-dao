// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LnBridgeV3Base} from "./common/LnBridgeV3Base.s.sol";
import {HelixLnBridgeV3} from "@helix/contracts/helix-contract/contracts/ln/lnv3/HelixLnBridgeV3.sol";

interface III {
	function balanceOf(address) external view returns (uint256);
    function withdraw(address token, address receiver, uint256 amount) external;
}

interface IProxyAdmin {
    function upgrade(address, address) external;
}

contract UpgradeXTokenBridge29 is LnBridgeV3Base {
	address private constant xring = 0xE7578598Aac020abFB918f33A20faD5B71d670b4;
	address private constant backing = 0xa64D1c284280b22f921E7B2A55040C7bbfD4d9d0;
    address private constant newImpl = 0x0616Af95b814a7c2E584140995ef7f83CC219802;
    address private constant receiver = 0xC665138b8AC77086af08d83cfc6410501624FFAa;
    bytes32 private constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
    bytes32 private constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function run() public sphinx {
        uint256 chainId = block.chainid;
		if (chainId == 46) {
			require(newImpl.code.length > 0, "!deploy");
			address admin = getAdminAddress(backing);
			IProxyAdmin(admin).upgrade(backing, newImpl);
			require(getImplementationAddress(backing) == newImpl, "!upgrade");
			// III(backing).withdraw(xring, receiver, III(xring).balanceOf(backing));
		}
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
