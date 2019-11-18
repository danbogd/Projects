pragma solidity >=0.5.0 <0.6.0;

import "./GetETHPrice.sol";

contract MultiOraclize is Price{

      // oraclize callback types:
      enum oraclizeState { Bitfinex, Bitmex }
      
      function() external payable{}
      
      //Events
      event Bitfinex_PRICE(string result);

      event Bitmex_PRICE(string result);
      

       // the oraclize callback structure: we use several oraclize calls.
       // all oraclize calls will result in a common callback to __callback(...).
       // to keep track of the different querys we have to introduce this struct.
      struct oraclizeCallback {
            // for which purpose did we call? {Bitfinex | Bitmax}
            oraclizeState oState;
      }
      // Lookup state from queryIds
      mapping (bytes32 => oraclizeCallback) public oraclizeCallbacks;

     
      
      //Function for distance retrieval
      function Bitfinex_price() payable public returns(bool sufficient) {
            bytes32 queryId = oraclize_query("URL", "json(https://api-pub.bitfinex.com/v2/tickers?symbols=tETHUSD).0.7");
            oraclizeCallbacks[queryId] = oraclizeCallback(oraclizeState.Bitfinex);
            return true;
      }

      function Bitmex_price() payable public returns(bool sufficient) {
         bytes32 queryId =  oraclize_query("URL","json(https://www.bitmex.com/api/v1/instrument/active).10.prevClosePrice");
         oraclizeCallbacks[queryId] = oraclizeCallback(oraclizeState.Bitmex);
         return true;
      }
      
   
      
      uint public price1;
      uint public price2;
      //Function callback
      function __callback(bytes32 myid, string memory result) public {

                 if (msg.sender != oraclize_cbAddress()) revert();
                 oraclizeCallback memory o = oraclizeCallbacks[myid];
                 
                 if (o.oState == oraclizeState.Bitfinex) {
                              price1  = parseInt(result);
                              emit Bitfinex_PRICE(result);
                             
               }
                 else if(o.oState == oraclizeState.Bitmex) {
                              price2 = parseInt(result);
                              emit Bitmex_PRICE(result);
               }

      }

      function Update_ETHUSD_Price2() public { // add OnlyOwner 
      require (price1 > 10000 && price2 > 10000);
      if (price1 >= price2){ETHUSD = price2;}
      
      else {ETHUSD = price1;}
      update = now;
      }
}  
