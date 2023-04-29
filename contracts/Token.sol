// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";




contract NetworkAi is ERC20,Ownable , ERC20Permit, ERC20Votes  {
   
    address _primaryOwner;
    uint256 supplementaryTkRicompense;
    
    mapping (address => uint256) public _balances;
    event Transfer(address _owner, uint256 value);
    
    
    constructor() ERC20("NetworkAi", "NAI") ERC20Permit("NetworkAi") {
        _mint(msg.sender, 50000000 * 10**18);
        _primaryOwner = msg.sender;

        emit Transfer(msg.sender, 50000000 * 10**18);
    }


    function transfer(address _receiver,uint256 _amount) public override returns (bool) {


        require(_balances[msg.sender] >= _amount , "Insufficient balance");
        require(_receiver != msg.sender , "You cannot transfer to yourself");
        
        _balances[msg.sender] = _balances[msg.sender] - _amount;
        _balances[_receiver] = _balances[_receiver] + _amount;

        emit Transfer(_receiver, _amount);

        return true;
    }



    function Ricompense(address _to) public  {
        require(msg.sender == _primaryOwner , "You aren't owner");
        require(supplementaryTkRicompense <= (50000000 * 10**18) - (10 * 10**18) , 
            "Maximum rewards achieved"
        );
        require(_to != msg.sender , "You cannot transfer to yourself");

        _mint(_to, 10 * 10**18);
        supplementaryTkRicompense += 10 * 10**18;
       
    }



    function balanceOf() public view returns (uint256) {
        return _balances[msg.sender];
    }
    

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }


    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }


    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }
    
}
