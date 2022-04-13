// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NonToken is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("NonToken", "NON") {}

    address private Auction;

    function approveAuction(address _auction) public {
        Auction = _auction;
    }

    function setApproveAuction(uint _tokenId) public {
        approve(Auction, _tokenId);
    }

    function safeMint(string memory uri) private {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // function sendToken(address _from, address _to, uint _tokenId) public {
    //     safeTransferFrom(_from, _to, _tokenId);
    // }

    // function sales(uint _tokenId, uint __startingBid)
}