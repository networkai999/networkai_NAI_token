// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol";
import "../contracts/Token.sol";

contract NetworkAiTest is NetworkAi {

    function testTokenInitialValues() public {
        Assert.equal(name(), "NetworkAi", "token name did not match");
        Assert.equal(symbol(), "NAI", "token symbol did not match");
        Assert.equal(decimals(), 18, "token decimals did not match");
        Assert.equal(totalSupply(), 50000000 * 10**18, "token supply should be zero");
    }
}