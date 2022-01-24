// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol"; //totalsupply()

contract NftStats {
    uint immutable private supply;

    constructor (address _contract_address){
        supply = ERC721Enumerable(_contract_address).totalSupply();
    }

    function getSupply() public view returns (uint){
        return supply;
    }
}
