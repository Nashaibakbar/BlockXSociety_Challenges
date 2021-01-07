pragma solidity >=0.4.8 <0.8.0 ;


contract IERC223Recipient { 
    function tokenFallback(address _from, uint _value, bytes memory _data) public;
}

library SafeMath{

 function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    
 function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }
    
function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
}

contract ERC20{
    function balanceOf(address account) public view returns (uint);
    function transfer(address to, uint value) public returns (bool success);
    function totalSupply() public view returns(uint256);
    function approve(address spender,uint256 value) public returns (bool); 
    function transferFrom(address from,address to,uint256 value) public payable returns (bool);
    
    event Transfer(address,address,uint);
    event Approval(address, address, uint);
    
}

contract ERC223{
    function transfer(address to, uint value, bytes  data) public returns (bool success);
    event Transfer(address indexed from, address indexed to, uint value, bytes data);
}

contract MyToken is ERC20,ERC223 {
    
    using SafeMath for uint256;


    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;
    
    
   
    constructor () public
        {
        _name = "FarhanCoin";
        _symbol = "FRX";
        _decimals = 18;
        _totalSupply=100000;
        _balances[msg.sender]+=_totalSupply;
        }

        function name() 
    external
    view
    returns(string memory)
    {
        return _name;
    }
    
    function symbol()
    external
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
    
    function balanceOf(address account) 
    public
    view
    
    returns(uint256)
    {
        return _balances[account];
    }


  function approve(address spender,uint256 value) 
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

    _balances[from] = SafeMath.sub(_balances[from],value);
    _balances[to]   =  SafeMath.add(_balances[to],value);
    _allowed[from][msg.sender] = SafeMath.sub(_allowed[from][msg.sender],value);
    emit Transfer(from, to, value);
    return true;
   }

  function transfer(
  address _to,
  uint _value,
  bytes_data
  ) 
  public
  returns 
  (bool success){
      
    if(isContract(_to)) {
        return transferToContract(_to, _value, _data);
    }
    else {
        return transferToAddress(_to, _value, _data);
    }
}
  
  function transfer(
  address _to,
  uint _value
  ) 
  public 
  returns 
  (bool success) 
  {
      
    bytes memory empty;
    if(isContract(_to)) {
        return transferToContract(_to, _value, empty);
    }
    else {
        return transferToAddress(_to, _value, empty);
    }
}
 
  function isContract(address _addr)
  view
  private
  returns 
  (bool is_contract) {
      uint length;
      assembly {
            length := extcodesize(_addr)
      }
      return (length>0);
    }

  function transferToContract(
  address _to,
  uint _value,
  bytes memory _data
  )
  private
  returns 
  (bool success) {
    if (balanceOf(msg.sender) < _value) revert();
    _balances[msg.sender] = SafeMath.sub(_balances[msg.sender],_value);
    _balances[_to] = SafeMath.add(_balances[msg.sender],_value);
     
    IERC223Recipient receiver = IERC223Recipient(_to);
    receiver.tokenFallback(msg.sender, _value, _data);
    emit Transfer(msg.sender, _to, _value, _data);
    return true;
}

  function transferToAddress(
  address _to,
  uint _value,
  bytes memory _data) 
  private
  returns
  (bool success) {
    if (balanceOf(msg.sender) < _value) revert();
    _balances[msg.sender] = SafeMath.sub(_balances[msg.sender],_value);
    _balances[_to] = SafeMath.add(_balances[msg.sender],_value);
             
    emit Transfer(msg.sender, _to, _value, _data);
    return true;
  }

}

