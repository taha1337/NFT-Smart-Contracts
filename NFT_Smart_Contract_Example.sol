// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0; 

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

 contract MintContract is ERC721, Ownable {
    uint256 public mintPrice = 0.001 ether;
    uint256 public totalSupply;
    uint256 public maxSupply;
    bool public mintEnable; // Default is false
    mapping(address => uint256) public mintedWallets;

    constructor() payable ERC721('Simple Mint', 'SIMPLEMINT') {
        maxSupply = 2;
    }

    function toggleMinting() external onlyOwner {
        mintEnable = !mintEnable;
    }

    function setMaxSupply(uint256 _maxSupply) external onlyOwner{
        maxSupply = _maxSupply;
    }
    function mint() external payable {
        require(mintEnable, 'Minting is disabled');
        require(mintedWallets[msg.sender] < 1, 'exceeds max');
        require(msg.value == mintPrice, 'incorrect value');
        require(maxSupply > totalSupply, 'no longer available');
        mintedWallets[msg.sender]++;
        totalSupply++;
        uint256 tokenID = totalSupply;
        _safeMint(msg.sender, tokenID); // Mint NFT using _safemint (ERC721), handles minting and distribution
    }
}