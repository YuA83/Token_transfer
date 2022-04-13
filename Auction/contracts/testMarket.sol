// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// 성공! => 대충간단하게
import "./testNFT.sol";

contract Market {
    address private NFTaddress; // BscNFT address

    mapping(uint => address) highAddress;
    mapping(uint => uint) highAmount;

    constructor(address _NFTaddress) {
        NFTaddress = _NFTaddress; // BscNFT address
        setApproveAddress(address(this)); // set the Market address to approve
    }

    // set the Market address to approve
    function setApproveAddress(address _Marketaddress) private {
        NFT _nft = NFT(NFTaddress);
        _nft.setApproveAddress(_Marketaddress);
    }

    function bid(uint _tokenId) public payable {
        highAddress[_tokenId] = msg.sender;
        highAmount[_tokenId] = msg.value;
    }

    function end(uint _tokenId) public payable {
        NFT _nft = NFT(NFTaddress);
        address seller = _nft.ownerOf(_tokenId);
        payable(seller).transfer(highAmount[_tokenId]);
        _nft.sendToken(_tokenId, highAddress[_tokenId]);
    }
}