// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Base} from "./common/Base.sol";

interface III {
    function setURI(string memory) external;
    function setBaseURI(string memory baseURI) external;
    function setURI(uint256 tokenId, string memory tokenURI) external;
}

contract SetHelixboxNFTUrl is Base {
    address nft = 0x3288D1f4bD290D3e9006aA196f1c46D035d789Bf;

    function run() public sphinx {
        address dao = safeAddress();
        III(nft).setURI("ipfs://bafybeibstdzjahalez6fcrrgy6sr6szebgeybdpjay7eqda5xq6phpbnda/{id}.json");
        III(nft).setBaseURI("ipfs://bafybeibstdzjahalez6fcrrgy6sr6szebgeybdpjay7eqda5xq6phpbnda/");
        III(nft).setURI(1, "1.json");
        III(nft).setURI(2, "2.json");
    }
}
