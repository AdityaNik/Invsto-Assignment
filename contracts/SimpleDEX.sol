// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleDEX {
    address public owner;
    address public tokenA;
    address public tokenB;
    uint public exchangeRate;

    // to check that only onwer can modify things
    modifier onlyOwner() {
        require(msg.sender == owner, "Not an owner");
        _;
    }

    // initialize the contract with user given addresses and exchange rate
    constructor(address _tokenA, address _tokenB, uint _exchangeRate){
        owner = msg.sender;
        tokenA = _tokenA;
        tokenB = _tokenB;
        exchangeRate = _exchangeRate;
    }

    // set new Exchange rate with onlyOwner modifier 
    function setExchangeRate(uint _newRate) external onlyOwner {
        exchangeRate = _newRate;
    }

    // exchange TokenA for TokenB
    function exchangeTokenAForTokenB(uint amountA) external {
        uint amountB =  amountA * exchangeRate;
        require(IERC20(tokenB).balanceOf(address(this)) >= amountB, "Insufficient tokenB");

        require(IERC20(tokenA).transferFrom(msg.sender, address(this), amountA), "tokenA transfer failed");
        require(IERC20(tokenB).transfer(msg.sender, amountB), "TokenB transfer failed");
    }

    // exchange TokenB for TokenA
    function exchangeTokenBForTokenA(uint amountB) external {
        uint amountA = amountB / exchangeRate;
        require(IERC20(tokenA).balanceOf(address(this)) >= amountA, "Insufficient tokenA");

        require(IERC20(tokenB).transferFrom(msg.sender, address(this), amountB), "tokenB transfer failed");
        require(IERC20(tokenA).transfer(msg.sender, amountA), "tokenB transfer failed");
    }
}
