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

    //change
    sNFT constant nft = sNFT(0x7E9C840F21429e63E4b32ae70B6e7A21272a579a);
    sERC20 constant EXP = sERC20(0x3EA9633264450298b9147E38955D2c07E4A03a86);

    function setUp() public {
        cheats.label(0x11dc744F9b69b87a1eb19C3900e0fF85B6853990, "deployer");
        cheats.label(0x7E9C840F21429e63E4b32ae70B6e7A21272a579a, "sNFT");
        cheats.label(0x3EA9633264450298b9147E38955D2c07E4A03a86, "sERC20");
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
        EXP.mint(user1, 35);
        EXP.mint(user2, 65);
        EXP.mint(deployer, 85);
    }

}