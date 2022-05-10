pragma solidity ^0.8.4;

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
        payable(msg.sender).call{value: amount}("");
    }
    function tokenDeposit(uint256  amount, bytes32 symbol) external{
        
    }

}
