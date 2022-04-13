// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NonToken is ERC721URIStorage {
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address winner, uint amount);

    // IERC721 public nft;
    uint public nftId;

    address payable public seller;
    uint public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;

    mapping(address => uint) public bids;
    mapping(uint => address) public tokenOwner;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("NonToken", "NON") {}

    function safeMint(string memory uri) private {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function sales(uint _tokenId, uint _startingBid) public {
        require(!started, "started");
        require(msg.sender == ownerOf(_tokenId), "not seller");

        nftId = _tokenId;
        tokenOwner[_tokenId] = msg.sender;
        safeTransferFrom(msg.sender, address(this), _tokenId);
        highestBid = _startingBid;
        started = true;
        endAt = block.timestamp + 7 days;

        emit Start();
    }

    function bid() public payable {
        require(started, "not started");
        require(block.timestamp < endAt, "ended");
        require(msg.value > highestBid, "value < highest");

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit Bid(msg.sender, msg.value);
    }

    function withdraw() public {
        uint _amount = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(_amount);

        emit Withdraw(msg.sender, _amount);
    }

    function end() public {
        require(started, "not started");
        require(block.timestamp >= endAt, "not ended");
        require(!ended, "ended");

        ended = true;

        if (highestBidder != address(0)) {
            safeTransferFrom(address(this), highestBidder, nftId);
            payable(tokenOwner[nftId]).transfer(highestBid);
            delete tokenOwner[nftId];
        }
        else {
            safeTransferFrom(address(this), tokenOwner[nftId], nftId);
        }

        emit End(highestBidder, highestBid);
    }
}