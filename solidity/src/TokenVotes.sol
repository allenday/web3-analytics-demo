pragma solidity ^0.8.11;

// SPDX-License-Identifier: UNLICENSED

interface VoteEmitter {
	event observe(address indexed from,address indexed token_contract,uint256 indexed tokenId);
	event voteFor(address indexed from,address indexed token_contract,uint256 indexed tokenId);
	//event voteAgainst(address indexed from, uint256 indexed tokenId);
}

contract Votes is VoteEmitter {
	uint itemCount = 1006;
	mapping(address => mapping(uint => Stats)) public itemStats;

	struct Stats {
		// order matters - 36BFA4FB-2115-4D02-82FD-239E613D7557
		uint observations;
		uint hits;
	}

	function vote (address token_contract,uint256 tkid_for,uint256 tkid_against) public {
		unchecked {
			itemStats[token_contract][tkid_for].hits += 1;
			itemStats[token_contract][tkid_for].observations += 1;
			itemStats[token_contract][tkid_against].observations += 1;
		}
		emit voteFor(msg.sender,token_contract,tkid_for);
		emit observe(msg.sender,token_contract,tkid_for);
		//emit voteAgainst(msg.sender,token_contract,tkid_against);
		emit observe(msg.sender,token_contract,tkid_against);
	}

	function getStats(address token_contract) public returns (Stats[] memory) {
		//return itemStats; // that would be nice, but..
		Stats[] memory tub = new Stats[](itemCount);
		for(uint ii = 0; ii != itemCount; ii++) {
			tub[ii] = itemStats[token_contract][ii];
		}
		return tub;
	}
}
