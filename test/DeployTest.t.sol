// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/Cheats.sol";
import {SoulboundERC20} from "../src/SoulboundERC20.sol";
import {SoulboundNFT} from "../src/SoulboundNFT.sol";
import {LibRLP} from "./libraries/LibRLP.sol";

contract DeployTest is DSTest {
    Cheats constant cheats = Cheats(HEVM_ADDRESS);
    
    //change
    address constant deployer = 0x11dc744F9b69b87a1eb19C3900e0fF85B6853990;
    
    uint nonce = cheats.getNonce(deployer);

    address immutable sNFTAdress = LibRLP.computeAddress(deployer, nonce);
    address immutable sERC20Adress = LibRLP.computeAddress(deployer, nonce + 1);

    function deploy() public {
        cheats.startBroadcast(deployer);
        SoulboundNFT sNFT = new SoulboundNFT("Ethernaut XP Counter", "EXPC", sERC20Adress);
        SoulboundERC20 sERC20 = new SoulboundERC20("Ethernaut XP", "EXP", sNFTAdress);
    }
}