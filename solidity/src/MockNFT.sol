// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol"; //totalsupply()

contract mockNFT is ERC721, ERC721Enumerable {
    constructor() ERC721("mock", "MOCK") {}

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC721,ERC721Enumerable) {}
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721,ERC721Enumerable) returns (bool) {}

    function totalSupply() public view virtual override(ERC721Enumerable) returns (uint256) {
        return 1006;
    }
}