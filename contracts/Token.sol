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
    // initial mint amount
    uint256 mintAmount = 100000000 * 10**18;
    // number of reward tokens issued
    uint256 supplementaryTkRicompense;
    // max supply
    uint256 maxSupply = 150000000 * 10**18;
    // tokens for tasks completed by users
    uint256 ricompense = 10 * 10**18;
    // Check whether the user can claim his or her tokens 
    uint256 private _tokenChecker = 10278359485746330984340085;
    // Counter that calculates how many times tokens have been claimed
    int claimedCount = 0;
    // tokens released from rewards
    int tokenReleasedFR = 0;
    // max ricompense for claim
    uint256 maxRicompense = 50000000 * 10**18;
    


    mapping (address => uint256) public _balances;
    event TransferSent(address _from,address _to, uint256 _amount);
    event TransferMint(address _owner,uint256 _amount);
    event Received(address, uint);
        receive() external payable {
        emit Received(msg.sender, msg.value);
    }
    
    
    constructor() ERC20("NetworkAi", "NAI") ERC20Permit("NetworkAi") ERC20Capped(maxSupply) {
        primaryOwner = msg.sender;
        _mint(primaryOwner, mintAmount);
        _balances[primaryOwner] = mintAmount;

        emit TransferMint(primaryOwner, mintAmount);

    }


    function transfer(address _receiver,uint256 _amount) public virtual override returns (bool) {
        require(_amount <= _balances[msg.sender],"This wallet does not have enough balace to send");
        _transfer(_msgSender(), _receiver, _amount);
        return true;
        
    }


    function getClaim(address _receiver,uint256 _receiverToken) public  {
        
        require(_receiverToken == _tokenChecker, "You can't get your tokens");
        require(supplementaryTkRicompense <= (maxRicompense - ricompense) , 
            "Maximum rewards achieved"
        );

        NetworkAi._mint(_receiver, ricompense);
        _balances[_receiver] = ricompense;
       
        supplementaryTkRicompense += ricompense;
        emit TransferMint(_receiver, ricompense);

        // ++counter rewards
        claimedCount++;

        // + tokenReleasedFR
        tokenReleasedFR +=  10;

    }



    function balanceOf() public view returns (uint256) {
        return _balances[msg.sender];
    }

    // Function that returns the count of reward requests
    function countRewards() public view returns (int) {
        return claimedCount;
    }

    // Function that returns the number of tokens released so far from the rewards
    function tokenRFR() public view returns (int) {
        return tokenReleasedFR;
    }
    
    // returns max supply
    function getMaxSupply() public view returns (uint256) {
        return maxSupply;
    }

    // return supply in this moment
    function getSupply() public view returns (uint256) {
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
    
}
