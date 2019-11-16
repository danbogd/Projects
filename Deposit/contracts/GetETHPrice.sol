pragma solidity >=0.5.0 <0.6.0;
import "./oraclize.sol";
import "./Deposit.sol";

contract Price is usingOraclize, Recieve {
    
    uint public temp_ETHUSD; //  get ETHUSD price from coinmarketcap.com
    uint public update;
    
    event LogPriceUpdated(string price);
    event LogNewOraclizeQuery(string description);

    constructor () public {
        updatePrice();
    }
    
    function() external payable{}

    function __callback(bytes32 myid, string memory result) public {
        if (msg.sender != oraclize_cbAddress()) revert();
        temp_ETHUSD = parseInt(result)/10000000;
        emit LogPriceUpdated(result);
    }

    function updatePrice() public payable { // add OnlyOwner
        if (oraclize_getPrice("URL") > address(this).balance) {
        emit    LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
        emit    LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            oraclize_query("URL", "json(https://api.coinmarketcap.com/v1/ticker/ethereum/?convert=USD).0.price_usd");
        }
    }
    
    function BalanceOfThisContract() public view returns (uint){
        return address(this).balance;
    }
    
    uint public ETHUSD;
    
    function Update_ETHUSD_Price() public { // add OnlyOwner
        require (address(this).balance >= 5 finney, "Add some ETH to cover for the query fee");
        ETHUSD = temp_ETHUSD;
        require (temp_ETHUSD > 10000, "The price is not correct");
        update = now;
    } 
} 
 




