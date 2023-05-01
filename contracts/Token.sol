// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";




contract NetworkAi is ERC20,Ownable , ERC20Permit, ERC20Votes  {
   
    address _primaryOwner;
    uint256 _mintAmount = 100000000 * 10**18;
    uint256 supplementaryTkRicompense;
    uint256 maxSupply = 100000000 * 10**18;
    uint256 ownerAmount =  _mintAmount / 10;


    mapping (address => uint256) public _balances;
    event TransferSent(address _from,address _to, uint256 _amount);
    event TransferMint(address _owner,uint256 _amount);
    
    
    constructor() ERC20("NetworkAi", "NAI") ERC20Permit("NetworkAi") {
        _primaryOwner = msg.sender;
        _mint(_primaryOwner, _mintAmount);
        _balances[_primaryOwner] = ownerAmount;
        emit TransferMint(_primaryOwner, ownerAmount);

    }


    function transfer(address _receiver,uint256 _amount) public override returns (bool) {


        require(_balances[msg.sender] >= _amount, "Insufficient balance");
        require(_receiver != msg.sender , "You cannot transfer to yourself");
        
        _beforeTokenTransfer(msg.sender, _receiver, _amount);

        _balances[msg.sender] = _balances[msg.sender] - _amount;
        _balances[_receiver] = _balances[_receiver] + _amount;

        emit TransferSent(msg.sender, _receiver, _amount);
        _afterTokenTransfer(msg.sender, _receiver, _amount);
        emit Transfer(msg.sender, _receiver, _amount);
        
        return true;
       
    }

    event Received(address, uint);
        receive() external payable {
        emit Received(msg.sender, msg.value);
    }



    function Ricompense(address _receiver) public  {
        require(msg.sender == _primaryOwner , "You aren't owner");
        require(supplementaryTkRicompense <= (50000000 * 10**18) - (10 * 10**18) , 
            "Maximum rewards achieved"
        );
        require(_receiver != msg.sender , "You cannot transfer to yourself");

        _mint(_receiver, 10 * 10**18);
        supplementaryTkRicompense += 10 * 10**18;
        emit TransferSent(msg.sender, _receiver, 10 * 10**18);
       
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
