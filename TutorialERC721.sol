// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @custom:security-contact game@gamename.com
contract TutorialERC721 is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable, ERC721Burnable {
   
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    address private _securityAddress;

    constructor() ERC721("TutorialERC721", "ERC721") {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://tutorial.jimpanda.com/nft721/";
    }

    function setSecurityAddress(address securityAddress) external onlyOwner{
        _securityAddress = securityAddress;
    }

    function addERC721(address account) external{
        require(msg.sender == _securityAddress, "Not allowed to addERC721");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(account, tokenId);  
    }

    function upgradeNFT(address from, uint256 upgrade1ID, uint256 upgrade2ID) external{
        require(msg.sender == _securityAddress, "Not allowed to Upgrade NFTs");
        require(ownerOf(upgrade1ID) == from, "You need to be owner");
        require(ownerOf(upgrade2ID) == from, "You need to be owner");
        _burn(upgrade1ID);
        _burn(upgrade2ID);
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(from, tokenId);
    }

    function getAllNFTs(address account) external view returns (uint[] memory){
        uint balance = IERC721Enumerable(this).balanceOf(account);
        uint[] memory tokens = new uint[](balance);
        for (uint i=0; i<balance; i++) {
            tokens[i] = (IERC721Enumerable(this).tokenOfOwnerByIndex(account, i));
        }
        return tokens;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public pure override(ERC721, ERC721URIStorage) returns(string memory){
        return(string(abi.encodePacked("https://tutorial.jimpanda.com/nft721/", Strings.toString(tokenId), ".json")));
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}