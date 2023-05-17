// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/utils/Strings.sol";




contract NetworkAi is ERC20,Ownable , ERC20Permit, ERC20Votes , ERC20Capped  {
        
        
    

    
    // address owner
    address primaryOwner;
    address payable public _owner;
    // initial mint amount ---  1Mrd
    uint256 initialAmount = 1000000000 * 10**18; 
    // max mintable after first mint ---  1Mrd
    uint256 maxMintable = 1000000000 * 10**18;
    // max supply ---  2Mrd
    uint256 maxSupply = initialAmount + maxMintable;
    // mined tokens
    uint256 minedTokens;
    
 

    mapping (address => uint256) public _balances;
    event TransferSent(address _from,address _to, uint256 _amount);
    event TransferMint(address _owner,uint256 _amount);
    event Received(address, uint);
        receive() external payable {
        emit Received(msg.sender, msg.value);
    }
    
    
    
    constructor() ERC20("NetworkAi", "NAI") ERC20Permit("NetworkAi") ERC20Capped(maxSupply) {
        primaryOwner = msg.sender;
        _mint(primaryOwner, initialAmount);
        _balances[primaryOwner] = initialAmount;
        _owner = payable(msg.sender);

        emit TransferMint(primaryOwner, initialAmount);
        
    }


    function transfer(address _receiver,uint256 _amount) public virtual override returns (bool) {
        require(_amount <= _balances[msg.sender],"This wallet does not have enough balace to send");
        _transfer(_msgSender(), _receiver, _amount);
        emit Transfer(_msgSender(), _receiver, _amount);
        emit Received(_msgSender(),_amount);
        return true;
        
    }


    function balanceOf() public view returns (uint256) {
        return _balances[msg.sender];
    }


    function tokenBalance() public view returns (uint256) {
        return _balances[address(this)];
    }


    // returns max supply
    function getMaxSupply() public view returns (uint256) {
        return maxSupply;
    }

    // returns the tokens mined so far
    function getMinedToken() public view returns (uint256) {
        return minedTokens;
    }

    // return token mined 
    function getTotalSupply() public view returns (uint256) {
        return totalSupply();
    }

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }


    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes , ERC20Capped)
    {
        super._mint(to, amount);
    }


    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }


    function requestTokens (address requestor , uint256 amount) public  {
        //mint tokens
        require(maxMintable >= minedTokens + amount,"The minable maximum has been reached" );
        _mint(requestor, amount);
        _balances[requestor] = amount;
        emit TransferMint(requestor, amount);

        minedTokens += amount;
        
    }



    
}


