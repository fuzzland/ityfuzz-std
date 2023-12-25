// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.2 <0.9.0;

import {Test, console2} from "forge-std/Test.sol";
import {PancakePair} from "./UniswapV2.sol";

contract ItyFuzzTest is Test {
    // Flashloan related functions
    struct ConstantPair {
        address token;
        address faucet;
        uint256 ratio;
    }

    address[] public v2Pairs;
    ConstantPair[] public constantPairs;

    function registerUniswapV2Pair(address pair) internal {
        (bool is_token0_succ, ) = pair.call(
            abi.encodeWithSignature("token0()")
        );
        (bool is_token1_succ, ) = pair.call(
            abi.encodeWithSignature("token0()")
        );
        require(is_token0_succ || is_token1_succ, "not a uniswap v2 pair");
        v2Pairs.push(pair);
    }

    function createUniswapV2Pair(
        address token1,
        address token2
    ) internal returns (address) {
        PancakePair p = new PancakePair();
        p.initialize(token1, token2);
        registerUniswapV2Pair(address(p));
        return address(p);
    }

    function createConstantPair(
        address token,
        address faucet,
        uint256 ratio
    ) internal {
        ConstantPair memory pair = ConstantPair(token, faucet, ratio);
        constantPairs.push(pair);
    }
}
