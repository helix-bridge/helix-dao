// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Base} from "./common/Base.sol";

interface III {
    function setURI(string) external;
}

contract AcceptOwnership24 is Base {
    address nft = 0xB0262b25cc745A0AA6bd2ac914BF4b5F77506369;

    function run() public sphinx {
        address dao = safeAddress();
		III(nft).setURI("ipfs://bafybeiflaokhjwqnimgoz55a274ufeyvzjiyxvnk4iucwxwmbptaaab24a/{id}.json");
    }
}
