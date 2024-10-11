// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Marketplace {
    struct Item {
        uint256 id;
        address payable seller;
        uint256 price;
        bool sold;
    }

    uint256 public itemCount;
    mapping(uint256 => Item) public items;

    event ItemListed(uint256 id, address seller, uint256 price);
    event ItemSold(uint256 id, address buyer, uint256 price);

    function listItem(uint256 price) public {
        itemCount++;
        items[itemCount] = Item(itemCount, payable(msg.sender), price, false);
        emit ItemListed(itemCount, msg.sender, price);
    }

    function buyItem(uint256 id) public payable {
        Item storage item = items[id];
        require(id > 0 && id <= itemCount, "Item doesn't exist");
        require(msg.value == item.price, "Incorrect price");
        require(!item.sold, "Item already sold");

        item.seller.transfer(msg.value);
        item.sold = true;
        emit ItemSold(id, msg.sender, msg.value);
    }

    function getItem(uint256 id) public view returns (uint256, address, uint256, bool) {
        Item memory item = items[id];
        return (item.id, item.seller, item.price, item.sold);
    }
}
