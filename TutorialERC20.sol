// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "yourDesktopDestination/TutorialERC721.sol";
import "yourDesktopDestination/TutorialERC1155.sol";

/// @custom:security-contact game@gamename.com
contract TutorialERC20 is Context, IERC20, Ownable{

    using SafeMath for uint256;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;
    uint8 private _decimals;
    string private _symbol;
    string private _name;
    address private _characterAdrress;
    address private _itemAdrress;

    TutorialERC721 _erc721 = TutorialERC721(ERC721contractAddress);                                // ERC721 Contract
    TutorialERC1155 _erc1155 = TutorialERC1155(ERC1155contractAddress);                              // ERC1155 Contract
    address private _gameAddress = GameWalletAddress;                                              // Game Wallet
    uint256 private _nft11552 = 500000000000000000000;                                             // Cost 1155_2 NFT
    uint256 private _nft11551 = 200000000000000000000;                                             // Cost 1155_1 NFT
    uint256 private _nft721 = 100000000000000000000;                                               // Cost 721 NFT
    uint256 private _upgrade = 10000000000000000000;                                               // Cost Upgrade

    constructor(){
        _name = "Tutorial Coin";
        _symbol = "ERC20";
        _decimals = 18;
        _totalSupply = 1000000000000000000000000;
        _balances[msg.sender] = _totalSupply;

        emit Transfer(address(0), msg.sender, _totalSupply);
    }
    
    function upgradenft(address to, uint256 amount, uint256 upgrade1ID, uint256 upgrade2ID) external returns (bool){
        _transfer(_msgSender(), to, amount);
        if(to == _gameAddress && amount == _upgrade){
            address from = _msgSender();
            _erc721.upgradeNFT(from, upgrade1ID, upgrade2ID);
        }
        return true;
    }

    function transfer(address recipient, uint256 amount) external returns (bool){
        _transfer(_msgSender(), recipient, amount);
        if(recipient == _gameAddress && amount == _nft721){
            _erc721.addERC721(_msgSender());
        } 
        if(recipient == _gameAddress && amount == _nft11551){
            _erc1155.addERC1155_1(_msgSender());
        }
        if(recipient == _gameAddress && amount == _nft11552){
            _erc1155.addERC1155_2(_msgSender());
        }
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        _transfer(from, to, amount);
        _approve(from, _msgSender(), _allowances[from][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function getOwner() external view returns (address) {
        return owner();
    } 

    function decimals() external view returns (uint8) {
        return _decimals;
    }
    
    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }
    
    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}
