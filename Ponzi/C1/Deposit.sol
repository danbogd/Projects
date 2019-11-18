pragma solidity >=0.5.0 <0.6.0;
import "./WhiteList.sol";
import "./IERC20.sol";
import "./SafeMath.sol";

contract Recieve is WhiteList {

    address public admin;
      
    constructor (address _admin) public{
     //searcher[msg.sender].push(0);
    require (_admin != address(0));
    admin = _admin;
    
    }
      
    struct Deposit{
    address user;
    address token;
    uint value;
    uint time;
    bool active;
    uint id;
    }
    
    mapping(uint => Deposit) public deposits;
    uint [] counter;
    
    
    address pax = 0x0000000000000000000000000000000000000001 ; // address PAX token contract;
    IERC20 Token = IERC20(pax); 
    
    
     
    event CreateDeposit(address user, address token, uint value, uint time, uint id);
    event WithdrawalEther(uint id, address user, uint amount);
    
    using SafeMath for uint256;
    address eth = 0x0000000000000000000000000000000000000000;
    
    uint public id;
    
    // struct of referrer 
    struct Ref{
    uint value;
    bool calc;
    }
    
    
    
    mapping (uint => mapping (address => Ref)) referrers;
    
    function deposit(address _referrer) public payable {
    //require (msg.value >= 0.01 ether && registry[msg.sender]);
    require (_referrer != address (0) && msg.sender != admin && msg.sender != _referrer);
    
    
    Deposit storage deposit = deposits[++id];
    
    deposit.user = msg.sender;
    deposit.token = eth;
    deposit.value = msg.value;
    deposit.time = now;
    deposit.active = true;
    deposit.id = id;
    
    counter.push(id)-1;
   
    
    
    emit CreateDeposit(msg.sender,eth, msg.value, now, id);
    
  }
  
    
/*
    function depositTokens(uint256 _amount) public {
    require (_amount >= 10 * 10 ** 18 && registry[msg.sender]);// !!!!!!!!!!!!!!! Узнать значение decimals
    //remember to call Token(address).approve(address(this), _amount) or this contract will not be able to do the transfer on your behalf.
    require (!Token.transferFrom (msg.sender,address(this), _amount));
    
    Contributor storage contributor = contributors[msg.sender];
    contributor.token = pax;
    contributor.value = _amount;
    contributor.time = now;
    
    contributorsAccts.push(msg.sender)-1;
    
    emit CreateDeposit(msg.sender, contributor.token, _amount, now);
    }
    */
    //counter
    
    
    
   
    
    function getDeposit(uint _id) view public returns (address,address, uint, uint, bool, uint) {
        return (deposits[_id].user, deposits[_id].token, deposits[_id].value, deposits[_id].time, deposits[_id].active, deposits[_id].id);
    }
    
    
    // view my deposits
    function My_Deposits() external view returns(uint[] memory dep_Ids){
    Deposit storage deposit = deposits[id];
    
    uint j;
    for (uint i = 1; i <= id; i++){
        if (deposits[i].user == msg.sender)
        {j++;}
    }
     dep_Ids = new uint[](j);
     if (j > 0){
     
     uint j = 0;
      for (uint i = 1; i <= id; i++){ 
        if (deposits[i].user == msg.sender)
          dep_Ids[j++] = deposits[i].id ;
          
      }
     }
        return dep_Ids;
    }
    
    function Withdraw (uint _id) public{
    
    uint amount;
    address contributor;
    uint date;
    
    (contributor,,amount,date,,) = getDeposit(_id);
    //require (contributor==msg.sender && date + 14 days <= now);
    
    msg.sender.transfer(amount);
    delete deposits[_id];
     
    emit WithdrawalEther(_id, msg.sender, amount);
      
        
    }
    
}