// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./MyToken.sol";

contract Test {
    address tokenAddress;

    constructor(address _tokenAddress) {
        tokenAddress = _tokenAddress;
    }

    // function transToken(address[] memory _recipient, uint _amount) public {
    function transToken(address[] memory _recipient, uint[] memory _amount) public {
        MyToken _mytoken = MyToken(tokenAddress);
        for(uint i = 0; i < _recipient.length; i++) {
            _mytoken.tokenTransfer(msg.sender, _recipient[i], _amount[i]);
        }
    }
}