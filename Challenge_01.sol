// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.7.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";

contract MyToken {
    
    using SafeMath for uint256;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    
    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;
    
    
    event Transfer(address,address,uint);
    event Approval(address, address, uint);
 
    constructor (
        string memory name_,
        string memory symbol)
        {
        _name = name_;
        _symbol = symbol;
        _decimals = 18;
        _totalSupply=100000;
        _balances[msg.sender]+=_totalSupply;
        }

    
    function name() 
    public
    view
    returns(string memory)
    {
        return _name;
    }
    
    function symbol()
    public
    view 
    returns(string memory)
    {
        return _symbol;
    }
    
    function decimals()
    public 
    view 
    returns(uint8)
    {
        return _decimals;
    }
    
    function totalSupply() 
    public 
    view 
    returns(uint256)
    {
        return _totalSupply;
    }
    
    function balanceOf(
        address account
    ) 
    public
    view
    returns(uint256)
    {
        return _balances[account];
    }
    
    function transfer(
        address to,
        uint256 value
    ) 
        public
        payable
        returns (bool) 
    {
    require(value <= _balances[msg.sender]);
    require(to != address(0));

    _balances[msg.sender] = _balances[msg.sender].sub(value);
    _balances[to] = _balances[to].add(value);
    emit Transfer(msg.sender, to, value);
    return true;
    }

  function approve(
      address spender,
      uint256 value
     ) 
     public
     returns (bool) 
   {
    require(spender != address(0));

    _allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
   }
    
    
    function transferFrom(
    address from,
    address to,
    uint256 value
   )
    public payable
    returns (bool)
   {
    require(value <= _balances[from]);
    require(value <= _allowed[from][msg.sender]);
    require(to != address(0));

    _balances[from] = _balances[from].sub(value);
    _balances[to] = _balances[to].add(value);
    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
    emit Transfer(from, to, value);
    return true;
   }

 
    
}

