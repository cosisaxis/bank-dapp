// SPDX-License-Identifier: Unlicensed 
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Banking{
    address banker;
    bytes32[] public wlSymbols;
    mapping(bytes32 => address) public wlTokens;
    mapping(address => mapping(bytes32 => uint256)) public balances;

    constructor(){
        banker = msg.sender;
    }

    function wlToken(bytes32 symbol, address tokenAddress) external{
        require(msg.sender == banker, "not for you");

        wlSymbols.push(symbol);
        wlTokens[symbol] = tokenAddress;
    }

    function getWlSymbols() external view returns(bytes32[] memory){
        return wlSymbols;
    }

    function getWlTokenAddresses(bytes32 symbol) external view returns(address){
        return wlTokens[symbol];
    }

    receive() external payable{
        balances[msg.sender]['Eth'] += msg.value;
    }

    function removeEther(uint amount)external{
        require(balances[msg.sender]['Eth'] >= amount, 'You dont have enough funds to do this transaction');

        balances[msg.sender]['Eth'] -= amount;
       (bool success,) = payable(msg.sender).call{value: amount}("");
       require(success, "no success");

    }

    function tokensDeposit(uint256  amount, bytes32 symbol) external{
        balances[msg.sender][symbol] += amount;
        IERC20(wlTokens[symbol]).transferFrom(msg.sender, address (this), amount);        
    }

    function removeTokens(uint256 amount, bytes32 symbol) external{
        require(balances[msg.sender][symbol] >= amount, "You dont have enough funds to do this transact");

        balances[msg.sender][symbol] -= amount;
        IERC20(wlTokens[symbol]).transfer(msg.sender, amount);
    }

    function getTokenBalance(bytes32 symbol) external view returns(uint256){
        return balances[msg.sender][symbol];
    }

}
