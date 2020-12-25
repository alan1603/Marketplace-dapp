pragma solidity ^0.5.0;

contract marketplace{
    string public name;
    uint public productCount= 0;
    mapping(uint => product) public products;

    struct product{
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }

    event productCreated(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    event productPurchased(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    constructor() public{
        name = "Alan BaBU";
    }

    function createProduct(string memory _name, uint _price) public{

        require(bytes(_name).length > 0);
        require(_price > 0);
        productCount++;
        products[productCount] = product(productCount, _name, _price, msg.sender, false);
        emit productCreated(productCount, _name, _price, msg.sender, false);

    }

    function purchaseProduct(uint _id) public payable{
        product memory _product = products[_id];
        address payable _seller = _product.owner;
        require(_product.id>0 && _product.id<=productCount);
        require(msg.value >= _product.price);
        require(!_product.purchased);
        require(_seller != msg.sender);
        _product.owner = msg.sender;
        _product.purchased = true;
        products[_id] = _product;
        address(_seller).transfer(msg.value);
        emit productPurchased(productCount, _product.name, _product.price, msg.sender, true);
    }
}