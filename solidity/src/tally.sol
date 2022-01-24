pragma solidity ^0.8.11;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Tally { 

    uint itemCount;
    mapping( uint => Stats ) itemStats;

    struct Stats {
        uint observations;
        uint hits;
    }

    function init(address collectionAddress) public pure {
        for(int i = 0; i < collectionAddress.length; i++) {
            itemStats[i] = Stats(0, 0);
        }
    }

}
