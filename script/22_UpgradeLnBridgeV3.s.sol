// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {safeconsole} from "forge-std/safeconsole.sol";
import {LnBridgeV3Base} from "./common/LnBridgeV3Base.s.sol";
import {HelixLnBridgeV3} from "@helix/contracts/helix-contract/contracts/ln/lnv3/HelixLnBridgeV3.sol";

interface IProxyAdmin {
    function upgrade(address, address) external;
}

contract UpgradeLnBridge22 is LnBridgeV3Base {
    address private constant oldImpl = 0xdf383487CB33a3C78a884494e2456910d79d361c;
    bytes32 private constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
    bytes32 private constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function run() public sphinx {
        uint256 chainId = block.chainid;
        initLnBridgeAddress();
        address bridge = bridgerInfos[chainId].bridger;
		safeconsole.log("ChainId:", chainId);
        require(getImplementationAddress(bridge) == oldImpl, "!oldImpl");

        bytes memory code = type(HelixLnBridgeV3).creationCode;
        address impl = create2address(salt, keccak256(code));
        if (impl.code.length == 0) {
            create2deploy(salt, code);
        }
        require(impl.code.length > 0, "!deploy");

        address admin = getAdminAddress(bridge);
        IProxyAdmin(admin).upgrade(bridge, impl);
        require(getImplementationAddress(bridge) == impl, "!upgrade");
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
