// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.9.0;

contract SupplyChain {

  // <owner>
  address public owner;

  // <skuCount>
  uint public skuCount;

  // <ItemStruct mapping>
  mapping (uint =>ItemStruct)itemToPrice;

  // <enum State: ForSale, Sold, Shipped, Received>
enum State{ForSale, Sold, Shipped, Received}
  // <struct Item: name, sku, price, state, seller, and buyer>

  struct ItemStruct{
    string name;
    uint sku;
    uint price;
    State state;
    address payable seller;
    address payable buyer;

  }
  
  /* 
   * Events
   */

  // <LogForSale event: sku arg>
  event LogForSale(uint _sku);

  // <LogSold event: sku arg>
  event LogSold(uint _sku);

  // <LogShipped event: sku arg>
  event LogShipped(uint _sku);

  // <LogReceived event: sku arg>
  event LogReceived(uint _sku);


  /* 
   * Modifiers
   */

  // Create a modifer, `isOwner` that checks if the msg.sender is the owner of the contract

  // <modifier: isOwner
  modifier isOwner {
     require (msg.sender == owner, "You are not the owner");
      _;
   }


  modifier verifyCaller (address _address) { 
    require (msg.sender == _address); 
    _;
  }

  modifier paidEnough(uint _price) { 
    require(msg.value >= _price); 
    _;
  }

  modifier checkValue(uint _sku) {
    //refund them after pay for item (why it is before, _ checks for logic before func)
    _;
     uint _price = ItemStruct[_sku].price;
     uint amountToRefund = msg.value - _price;
     ItemStruct[_sku].buyer.transfer(amountToRefund);
  }

  // For each of the following modifiers, use what you learned about modifiers
  // to give them functionality. For example, the forSale modifier should
  // require that the item with the given sku has the state ForSale. Note that
  // the uninitialized Item.State is 0, which is also the index of the ForSale
  // value, so checking that Item.State == ForSale is not sufficient to check
  // that an Item is for sale. Hint: What item properties will be non-zero when
  // an Item has been added?

  modifier forSale{
    require(ItemStruct[_sku].State == State.Forsale, "State is not ForSale!");
    require(ItemStruct[_sku].seller != address(0),"seller address is 0x00");

    _;
  }
  modifier sold(uint _sku) {
require(ItemStruct[_sku].state == State.Sold, "state is not sold");
_;
  }
  modifier shipped(uint _sku){
require(ItemStruct[_sku].state == State.Shipped, "state is not shipped");
_;
  } 
  modifier received(uint _sku) {
require(ItemStruct[_sku].state == State.Received, "state is not sold");
    _;

  }

  constructor() public {
    // 1. Set the owner to the transaction sender
    owner = msg.sender;
    // 2. Initialize the sku count to 0. Question, is this necessary?
    skuCount = 0;
  }

  function addItem(string memory _name, uint _price) public returns (bool) {
    // 1. Create a new item and put in array
    // 2. Increment the skuCount by one
    // 3. Emit the appropriate event
    // 4. return true

    //hint:
    ItemStruct[skuCount] = itemToPrice({
     name: _name, 
     sku: skuCount, 
     price: _price, 
     state: State.ForSale, 
     seller: msg.sender, 
     buyer: address(0)
    });
    
    skuCount = skuCount + 1;
    emit LogForSale(skuCount);
    return true;
  }

  // Implement this buyItem function. 
  // 1. it should be payable in order to receive refunds
  // 2. this should transfer money to the seller, 
  // 3. set the buyer as the person who called this transaction, 
  // 4. set the state to Sold. 
  // 5. this function should use 3 modifiers to check 
  //    - if the item is for sale, 
  //    - if the buyer paid enough, 
  //    - check the value after the function is called to make 
  //      sure the buyer is refunded any excess ether sent. 
  // 6. call the event associated with this function!
  function buyItem(uint sku) public payable
    forsale(sku)
    paidEnough(ItemStruct[sku].price)
checkValue(sku){
  bool sendValue
  }

  // 1. Add modifiers to check:
  //    - the item is sold already 
  //    - the person calling this function is the seller. 
  // 2. Change the state of the item to shipped. 
  // 3. call the event associated with this function!
  function shipItem(uint sku) public {}

  // 1. Add modifiers to check 
  //    - the item is shipped already 
  //    - the person calling this function is the buyer. 
  // 2. Change the state of the item to received. 
  // 3. Call the event associated with this function!
  function receiveItem(uint sku) public {}

  // Uncomment the following code block. it is needed to run tests
   function fetchItem(uint _sku) public view  returns (string memory name, uint sku, uint price, uint state, address seller, address buyer) 
  { 
    name = ItemStruct[_sku].name; 
    sku = ItemStruct[_sku].sku; 
     price = ItemStruct[_sku].price; 
     state = uint(ItemStruct[_sku].state);
     seller = ItemStruct[_sku].seller; 
    buyer = ItemStruct[_sku].buyer; 
    return (name, sku, price, state, seller, buyer); 
   }
}
