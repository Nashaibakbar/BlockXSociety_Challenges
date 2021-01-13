// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol";

contract MyGame is ERC1155 {
    uint256 constant POKEMON_CARD= 0;// Index
    uint256 constant GOLD_COINS = 1;
    uint256 constant SILVER_CONIS = 2;
    uint256 constant POKEMON_CARD_SUPPLY=1;
    uint256 constant GOLD_COINS_SUPPLY=10000;
    uint256 constant SILVER_CONIS_SUPPLY=20000;
    

    constructor() public ERC1155("") {
        
        _mint(msg.sender, POKEMON_CARD, POKEMON_CARD, "");
        _mint(msg.sender, GOLD_COINS, GOLD_COINS_SUPPLY, "");
        _mint(msg.sender, SILVER_CONIS, SILVER_CONIS_SUPPLY, "");
    }
}
