// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 성공!
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    constructor() ERC721("NFT", "NFT") {}

    address private Marketaddress;

    function setApproveAddress(address _Marketaddress) public {
        Marketaddress = _Marketaddress;
    }

    function setApprove(uint256 _tokenId) private {
        approve(Marketaddress, _tokenId);
    }

    function createToken(string memory _tokenURI) public {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
    }

    function sales(uint _tokenId) public {
        setApprove(_tokenId);
    }

    function sendToken(uint256 _tokenId, address _to) public {
        address seller = ownerOf(_tokenId);
        safeTransferFrom(seller, _to, _tokenId);
    }
}