pragma solidity >=0.5.0 <0.6.0;


//import "./Ownable.sol";
//import "./IERC20.sol";
//import "./WhiteList.sol";
//import "./SafeMath.sol";
//import "./oraclize.sol";
//import "./Deposit.sol";
//import "./GetETHPrice.sol";
import "./MultiOraclize.sol";


contract CompanyEscrows is MultiOraclize{
    
    uint public start; 
    
    constructor() public {
    start = now; 
    
    
    }
     
    address payable public escrow1 = 0x3B3F8445648F9Fb322d7b0399E82a7208F991C4F;
    address payable public escrow2 = 0xE9acb2303010DB750cbD95fC484047495A4d93d8;
    
    address payable public escrow3 = 0x0000000000000000000000000000000000000001;
    address payable public escrow4 = 0x0000000000000000000000000000000000000002; 
    
    function Change_Escrow1 (address payable _newaddress) 
        public
        onlyOwner
    {
        require (_newaddress != address(0x0));
        escrow1 = _newaddress;
    } 
    
    function Change_Escrow2 (address payable _newaddress) 
        public
        onlyOwner
    {
        require (_newaddress != address(0x0));
        escrow2 = _newaddress;
    } 
    
    function Change_Escrow3 (address payable _newaddress) 
        public
        onlyOwner
    {
        require (_newaddress != address(0x0));
        escrow3 = _newaddress;
    }  
    
    function Change_Escrow4 (address payable _newaddress) 
        public
        onlyOwner
    {
        require (_newaddress != address(0x0));
        escrow4 = _newaddress;
    }   
    
    //на 1-ый Ethereum-кошелёк – эквивалент 1500$ в ETH или PAX 1 раз в неделю;
    event Transfer1(address indexed from, address indexed to, uint256 value);
    
    bool public permissionFor2;
    bool public permissionFor3;
    bool public permissionFor4;
    
    function WithdrawalForEscrow1()
        public
    {   
    require(now >= start + 27 days && now < start + 29 days);
    
        if (address(this).balance >= 150000/ETHUSD*10e18){
        require(now - 1 days <= update && update <= now + 1 days && msg.sender == escrow1 );
        uint amount1 = 150000/ETHUSD*10e18;
        escrow1.transfer(amount1);
        emit Transfer1 (address(this), escrow1, amount1);
        }
        else if (Token.balanceOf(address(this)) >= 1500* PAXrate * 10e18) {
        uint PAX_amount = 1500* PAXrate * 10e18;
        require (!Token.transfer (msg.sender, PAX_amount));
        escrow1.transfer(PAX_amount);
        emit Transfer1 (address(this), escrow1, PAX_amount);
        }
    start += 28 days;
    permissionFor2 = true;   
    } 

    function WithdrawalForEscrow2()
        public
    {   
    
    require(permissionFor2);
    
        if (address(this).balance >= 350000/ETHUSD*10e18){
        require(now - 1 days <= update && update <= now + 1 days && msg.sender == escrow1 );
        uint amount2 = 350000/ETHUSD*10e18;
        escrow2.transfer(amount2);
        emit Transfer1 (address(this), escrow2, amount2);
        }
        else if (Token.balanceOf(address(this)) >= 3500 * PAXrate * 10e18) {
        uint PAX_amount2 = 3500 * PAXrate *10e18;
        require (!Token.transfer (msg.sender, PAX_amount2));
        emit Transfer1 (address(this), escrow2, PAX_amount2);
        }
    
    permissionFor2 = false;
    permissionFor3 = true;
    } 
    
    function WithdrawalForEscrow3()
        public
    {   
    
    require(permissionFor3);
    
        if (address(this).balance >= 200000/ETHUSD*10e18){
        require(now - 1 days <= update && update <= now + 1 days && msg.sender == escrow1 );
        uint amount3 = 200000/ETHUSD*10e18;
        escrow3.transfer(amount3);
        emit Transfer1 (address(this), escrow3, amount3);
        }
        else if (Token.balanceOf(address(this)) >= 2000 * PAXrate *10e18) {
        uint PAX_amount3 = 2000 * PAXrate *10e18;
        require (!Token.transfer (msg.sender, PAX_amount3));
        emit Transfer1 (address(this), escrow3, PAX_amount3);
        }
   
    permissionFor3 = false;
    permissionFor4 = true;
    } 
    
    function WithdrawalForEscrow4()
        public
    {   
    
    require(permissionFor4);
    
        if (address(this).balance >= 300000/ETHUSD*10e18){
        require(now - 1 days <= update && update <= now + 1 days && msg.sender == escrow1 );
        uint amount4 = 300000/ETHUSD*10e18;
        escrow4.transfer(amount4);
        emit Transfer1 (address(this), escrow4, amount4);
        }
        else if (Token.balanceOf(address(this)) >= 3000 * PAXrate * 10e18) {
        uint PAX_amount4 = 3000 * PAXrate *10e18;
        require (!Token.transfer (msg.sender, PAX_amount4));
        emit Transfer1 (address(this), escrow4, PAX_amount4);
        }
    
    permissionFor4 = false;
    
    }
    uint public PAXrate = 1;
    
    function PAXUSD_rate (uint _PAXrate) // 1 PAX = 1 USD
    public 
    onlyOwner 
    {
    PAXrate = _PAXrate;
    }
}



 
  
