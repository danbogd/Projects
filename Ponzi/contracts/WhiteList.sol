pragma solidity >=0.5.0 <0.6.0;

import "./Owned.sol";

contract WhiteList is Ownable {

    mapping (address => bool) registry; // registered users only

    function addUser (address _user) public onlyOwner returns (bool) {
    require (_user != address(0),  "The user can't be the zero address");
    return registry[_user]= true;
    }

  
    function removeUser (address _user) public onlyOwner returns (bool){
    return registry[_user]= false;
  }
    function user(address _user) public view returns (bool){
    return registry[_user];
    }
  }