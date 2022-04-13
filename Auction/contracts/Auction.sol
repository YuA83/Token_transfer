// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./NonToken.sol";

contract Auction {
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address winner, uint amount);

    address private TokenAddress;
    address payable public seller;
    uint saledTokenId;
    uint public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;

    mapping(address => uint) public bids;

    constructor(address _tokenAddress) {
        TokenAddress = _tokenAddress;
        NonToken _nonToken = NonToken(TokenAddress);
        _nonToken.approveAuction(address(this));
    }

    function sales(uint _tokenId, uint _startingBid) public {
        seller = payable(msg.sender);
        saledTokenId = _tokenId;
        highestBid = _startingBid;

        start(_tokenId);
    }

    function start(uint _tokenId) private {
        require(!started, "started");
        require(msg.sender == seller, "not seller");

        NonToken _nonToken = NonToken(TokenAddress);
        _nonToken.sendToken(seller, address(this), _tokenId);
        started = true;
        endAt = block.timestamp + 7 days;

        emit Start();
    }
}