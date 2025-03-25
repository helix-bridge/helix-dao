// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Base} from "./common/Base.sol";

interface III {
    function setURI(string memory) external;
    function setBaseURI(string memory baseURI) public;
    function setURI(uint256 tokenId, string memory tokenURI) public;
}

contract SetHelixboxNFTUrl is Base {
    address nft = 0x418B17066233977aD0CFf6FB9d6029b70804C29E;

    function run() public sphinx {
        address dao = safeAddress();
        III(nft).setURI("ipfs://bafybeiflaokhjwqnimgoz55a274ufeyvzjiyxvnk4iucwxwmbptaaab24a/{id}.json");
        III(nft).setBaseURI("ipfs://bafybeiflaokhjwqnimgoz55a274ufeyvzjiyxvnk4iucwxwmbptaaab24a/");
        III(nft).setURI(1, "1.json");
        III(nft).setURI(2, "2.json");
    }
}
