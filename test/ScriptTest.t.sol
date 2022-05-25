// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/Cheats.sol";

interface sNFT {
    function mint() external;
}

interface sERC20 {
    function setApprovedMinter(address, bool) external;
    function mint(address, uint256) external;
}

contract ScriptTest is DSTest {
    Cheats constant cheats = Cheats(HEVM_ADDRESS);
    
    //change
    address constant deployer = 0x11dc744F9b69b87a1eb19C3900e0fF85B6853990;
    address constant user1 = 0x694c09927bCe479AE4056E01BBA3A1b13871B9dc;
    address constant user2 = 0xc92cde29b53975348bA79955C7462fB0C97aAa9b;
    address constant user3 = 0x3FA02e2983Efe28218FD145Af220456579B7B442;
    address constant user4 = 0x6db2b6dB4B59c9F2BFAd9847A9b5a6391Bf6A2d0;

    //change
    sNFT constant nft = sNFT(0x3187E5Dc282CF5c4293E0E7149F39B687C2261B9);
    sERC20 constant EXP = sERC20(0x560816bdeeb5b4A09809dF7cb699cE121f59140a);

    function setUp() public {
        cheats.label(0x11dc744F9b69b87a1eb19C3900e0fF85B6853990, "deployer");
        cheats.label(0x0fd6EDC52Ed631d15fF03EeDa70103a92a819EE4, "sNFT");
        cheats.label(0xff1Bb5806eD355946295D1d6DA2BBA2696396095, "sERC20");
    }

    function nftMint() public {
        cheats.broadcast(deployer);
        nft.mint();
    }

    function approveEXP() public {
        cheats.broadcast(deployer);
        EXP.setApprovedMinter(deployer, true);
    }

    function EXPmint() public {
        cheats.startBroadcast(deployer);
        EXP.mint(deployer, 85);
    }

}