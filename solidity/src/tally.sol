pragma solidity ^0.8.11;

// SPDX-License-Identifier: UNLICENSED

interface TallyMan {
    event observe(address indexed from, uint256 indexed tokenId);
    event voteFor(address indexed from, uint256 indexed tokenId);
    //event voteAgainst(address indexed from, uint256 indexed tokenId);
}

contract Tally is TallyMan {
    uint itemCount = 1006;
    mapping(uint => Stats) public itemStats;

    struct Stats {
        uint observations;
        uint hits;
    }

    function vote (uint256 tkid_for,uint256 tkid_against) public {
        unchecked {
            itemStats[tkid_for].hits += 1;
            itemStats[tkid_for].observations += 1;
            itemStats[tkid_against].observations += 1;
        }
        emit voteFor(msg.sender,tkid_for);
        emit observe(msg.sender,tkid_for);
        //emit voteAgainst(msg.sender,tkid_against);
        emit observe(msg.sender,tkid_against);
    }

    function getStats() public returns (Stats[] memory) {
        //return itemStats; // that would be nice, but..
        Stats[] memory tub = new Stats[](itemCount);
        for(uint ii = 0; ii != itemCount; ii++) {
            tub[ii] = itemStats[ii];
        }
        return tub;
    }
}
