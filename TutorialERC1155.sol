// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/// @custom:security-contact game@gamename.com
contract TutorialERC1155 is ERC1155, Ownable, Pausable, ERC1155Burnable, ERC1155Supply {

    address private _securityAddress;

    uint256 public constant NFT1 = 0;
    uint256 public constant NFT2 = 1;
    uint256 public constant NFT3 = 2;

    constructor() ERC1155("yourWebUrl") {}

    function uri(uint256 tokenId) public view virtual override returns (string memory){
        return(string(abi.encodePacked("your Web Url", Strings.toString(tokenId), ".json")));
    }
    
    function setSecurityAddress(address securityAddress) external onlyOwner{
        _securityAddress = securityAddress;
    }

    function addERC1155_1(address account) external{
        require(msg.sender == _securityAddress, "Not allowed to mint NFT");
        bytes memory data = "";
        _mint(account, 1, 1, data);
    }

    function addERC1155_2(address account) external{
        require(msg.sender == _securityAddress, "Not allowed to mint NFT");
        bytes memory data = "";
        _mint(account, 2, 1, data);
    }


    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyOwner
    {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
