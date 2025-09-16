// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Base } from "./common/Base.sol";

interface III {
    function dao() external view returns (address);
    function pendingDao() external view returns (address);
    function acceptOwnership() external;
}

interface ISafe {
    function swapOwner(address prevOwner, address oldOwner, address newOwner) external;
}

contract SwapOwner28 is Base {
    address ranji = 0xe59261f6D4088BcD69985A3D369Ff14cC54EF1E5;
    address jane = 0x570FCA2c6f902949dBb90664Be5680fEc94A84f6;

    function run() public sphinx {
		address self = safeAddress();
	 	ISafe(self).swapOwner(0x88a39B052d477CfdE47600a7C9950a441Ce61cb4, ranji, jane);
    }
}
