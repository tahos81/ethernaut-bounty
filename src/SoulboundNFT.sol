// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import { Base64 } from "./libraries/Base64.sol";
import { URI } from "./libraries/URI.sol";

interface IERC20 {
    function balanceOf(address _owner) external view returns (uint256);
}

/// @notice Soulbound NFT showcasing an addresses EXP tokens.
/// @author Tahos81 (https://github.com/tahos81/ethernaut-bounty/blob/main/src/SoulboundNFT.sol)
contract SoulboundNFT is ERC721URIStorage {

    error Soulbound();
    
    //License: CC Attribution. Made by game-icons.net: https://game-icons.net/ and Aleta
    string constant initialSVGpart1 = '<svg width="512" height="512" viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="b" x1="100%" y1="0%" x2="0%" y2="0%"><stop offset="0%" style="stop-color:#ffffff"/><stop offset="10%" style="stop-color:#666666"/><stop offset="30%" style="stop-color:#333333"/><stop offset="70%" style="stop-color:#333333"/><stop offset="90%" style="stop-color:#666666"/><stop offset="100%" style="stop-color:#ffffff"/></linearGradient><filter id="a" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="270" width="270"><feDropShadow dx="1" dy="1" stdDeviation="2" flood-opacity=".625" width="200%" height="200%"/></filter></defs><pattern id="c" x="0" y="0" width="100%" height="100%"><rect x="-150%" width="200%" height="150%" fill="url(#b)" transform="rotate(-65)"><animate attributeType="XML" attributeName="x" from="-150%" to="50%" dur="4s" repeatCount="indefinite"/></rect><rect x="-350%" width="200%" height="150%" fill="url(#b)" transform="rotate(-65)"><animate attributeType="XML" attributeName="x" from="-350%" to="-150%" dur="4s" repeatCount="indefinite"/></rect></pattern><path fill="url(#c)" d="M280.2 51.8h-3.9v-9.7h4c1.7 0 3 .5 3.8 1.5.8 1 1.2 2.1 1.2 3.3 0 .7-.2 1.5-.5 2.2-.3.8-.9 1.4-1.7 1.9-.6.5-1.6.8-2.9.8zm-79.1 31c.1-12.1.6-25 1.9-36.8 1-9 2.8-17.2 4.9-23.8 15.7-6.5 32-10.2 48.1-10.2s32.4 3.7 48.2 10.2c2.1 6.5 3.9 14.8 4.9 23.8 1.3 11.8 1.7 24.7 1.9 36.8-33.9-3.7-76.1-3.7-109.9 0zm71.8-18h3.5v-9.6h3.9c2 0 3.6-.4 5-1.2 1.3-.8 2.3-1.8 2.8-3.1.6-1.3.9-2.6.9-4.1 0-2.5-.8-4.5-2.4-5.9-1.6-1.4-3.8-2.1-6.6-2.1h-7v26zm-30.3-3.4h-13.9v-8h12V50h-12v-7.9h13.4v-3.3h-16.9v26h17.4v-3.4zm7.9 3.4 6.2-10.4 6.8 10.4h4.5l-8.6-13.2 8.2-12.9h-4.2l-5.9 9.9-6.5-9.9h-4.4l8.2 12.6-8.6 13.4h4.3zM233 403.2v29c8.2 1.2 16 1.8 23 1.8s14.8-.7 23-1.8v-29c-7.8.6-15.5.8-23 .8s-15.2-.3-23-.8zM89.2 377.5c.2.4.6 1.2 1.7 2.2 2.5 2.2 6.7 5.2 12.1 8.4 10.9 6.4 26.5 13.8 44.2 20.6 21.2 8.2 45.4 15.7 67.7 20.4v-27.6c-39.5-5.1-79.9-18.3-108.4-44.5-3.6 1.2-7.3 3.4-10.3 6.4-4 4.1-6.5 9.4-7 14.1zm316.2-20.6c-28.5 26.1-68.9 39.3-108.4 44.5V429c22.4-4.7 46.6-12.1 67.7-20.4 17.7-6.9 33.3-14.2 44.2-20.6 5.4-3.2 9.7-6.2 12.1-8.4 1.1-1 1.5-1.8 1.7-2.2-.5-4.7-3-10-7.2-14.1-2.9-3-6.6-5.2-10.1-6.4zM103.5 334c29.3 43.3 96.8 60 152.5 60s123.2-16.7 152.5-60c39.2-57.8 32.5-151.3-.5-214.8-17.5-33.6-47.9-66.1-82.6-86.3.6 3.6 1.1 7.4 1.5 11.2 1.5 13.7 1.9 28.2 2 41.3 18.7 3.2 33 7.7 39 13.7 32 32 75.5 134.7 16 224-37.7 56.5-218.3 56.5-256 0-59.5-89.3-16-192 16-224 6-6 20.3-10.6 39-13.7.1-13.1.5-27.6 2-41.3.4-3.8.9-7.5 1.5-11.2-34.7 20.2-65 52.7-82.6 86.3-32.9 63.5-39.5 156.9-.3 214.8zm83-301.2zM156 114.5c-26.6 20.6-43 114.8-33.5 146.8 16.6-61.8 32-124 107.9-161.3-7-1.1-14.1-1.6-21.2-1.6-17.2.1-37.2 3.7-53.2 16.1zm-49.4 242.4zm237 98.1c-1.7-.7-3.4-1.1-4.9-1.1h-6.4v24.7h4.6c4.1 0 7.3-1 9.7-3.1 2.4-2.1 3.6-5.1 3.6-9 0-3.2-.7-5.7-2-7.6-1.4-1.9-2.9-3.2-4.6-3.9zm29 16.8h7.8l-3.8-9.7-4 9.7zM178.5 468c-1-.8-2.2-1.1-3.7-1.1-2.1 0-3.7.7-5.1 2.2-1.3 1.4-2 3.3-2 5.5 0 .5 0 1 .1 1.2l13-4.8c-.5-1.2-1.3-2.2-2.3-3zm79.7.6c-1.4-1-2.9-1.5-4.7-1.5-1.3 0-2.6.3-3.7 1-1.1.6-2 1.6-2.7 2.7-.7 1.2-1 2.5-1 4 0 1.4.3 2.8 1 3.9.7 1.2 1.6 2.1 2.8 2.8 1.2.7 2.4 1.1 3.8 1.1 1.8 0 3.4-.5 4.7-1.5 1.3-1 2.2-2.4 2.5-4.2v-4.4c-.4-1.7-1.3-3-2.7-3.9zm164.1-13.3c-1.9-1.1-3.9-1.7-6.2-1.7-2.3 0-4.3.6-6.2 1.7-1.9 1.1-3.3 2.7-4.4 4.6s-1.6 4.1-1.6 6.5c0 2.3.5 4.4 1.6 6.4 1.1 1.9 2.6 3.5 4.5 4.6 1.9 1.1 4 1.7 6.3 1.7 2.2 0 4.3-.6 6.1-1.7 1.8-1.1 3.3-2.7 4.3-4.6 1-1.9 1.6-4.1 1.6-6.4 0-2.4-.5-4.5-1.6-6.5s-2.6-3.5-4.4-4.6zm71.7-32.2V498H18v-74.9l59.3-39.5c.5.5 1.1 1 1.6 1.5 3.9 3.5 8.9 6.9 15 10.5 12.1 7.1 28.5 14.7 46.8 21.9 36.7 14.3 81 26.6 115.3 26.6s78.6-12.3 115.3-26.6c18.3-7.1 34.7-14.8 46.8-21.9 6.1-3.6 11.1-7 15-10.5.5-.5 1.1-1 1.6-1.5l59.3 39.5zM84.8 453.7h23.8v-3.9H84.8v3.9zm1.8 11.7v3.9h20.2v-3.9H86.6zm22.6 16.8h-25v3.9h24.9v-3.9zm19.6-18.3h-6.1V454h-5.1v9.9h-4.1v4h4.1v18.3h5.1v-18.3h6.1v-4zm27.2 5.8c0-2-.7-3.6-2.1-4.8-1.4-1.2-3.1-1.9-5.2-1.9-2 0-3.8.5-5.4 1.3-1.6.9-2.8 2.1-3.6 3.6v-23.5h-4.9v41.8h5v-10.5c0-1.6.3-3 .9-4.3s1.4-2.3 2.5-3c1-.7 2.2-1.1 3.5-1.1 1.4 0 2.4.4 3.1 1.1.7.7 1.1 1.7 1.1 3v14.8h5.1v-16.5zm12.8 9.1 17.7-6.2c-.7-3.1-2.1-5.4-4-7.2-2-1.7-4.4-2.6-7.3-2.6-2.3 0-4.4.5-6.3 1.6-1.9 1.1-3.4 2.5-4.5 4.3-1.1 1.8-1.6 3.8-1.6 6 0 2.3.5 4.3 1.5 6.1 1 1.8 2.4 3.2 4.3 4.2s4 1.5 6.5 1.5c1.3 0 2.6-.2 4-.7s2.7-1.1 3.9-1.9l-2.3-3.7c-1.8 1.3-3.6 1.9-5.5 1.9-1.4 0-2.7-.3-3.8-.9-1-.4-1.9-1.2-2.6-2.4zm37.8-15.9c-.9 0-1.9.3-3.1.8-1.2.5-2.3 1.2-3.4 2.2-1.1.9-1.9 2-2.5 3.2l-.4-5.3h-4.5v22.4h5V476c0-1.4.4-2.8 1.1-4.1.7-1.3 1.8-2.3 3.1-3 1.3-.7 2.8-1 4.4-1l.3-5zm27.7 6.8c0-2-.7-3.6-2.1-4.8-1.4-1.2-3.1-1.9-5.2-1.9s-3.9.5-5.5 1.4-2.8 2.2-3.6 3.8l-.3-4.3h-4.5v22.4h5v-10.5c0-2.4.6-4.5 1.9-6s2.9-2.4 4.9-2.4c1.4 0 2.4.4 3.1 1.1.7.7 1.1 1.7 1.1 3v14.8h5.1v-16.6zm31.6-5.9h-4.6l-.4 3.6c-.9-1.3-2-2.4-3.4-3.2-1.4-.8-3.1-1.2-5-1.2-2.1 0-4.1.5-5.8 1.5-1.7 1-3.1 2.4-4.2 4.2-1 1.8-1.5 4-1.5 6.4 0 2.4.5 4.6 1.5 6.3 1 1.8 2.3 3.1 4 4s3.6 1.4 5.8 1.4c1.9 0 3.6-.4 5.1-1.3 1.5-.9 2.7-1.8 3.5-2.9v3.7h5v-22.5zm29.6 0h-5v10.4c0 1.6-.3 3-.9 4.3-.6 1.3-1.4 2.3-2.4 3.1-1 .7-2.1 1.1-3.3 1.1-1.3 0-2.3-.4-3-1.2-.7-.7-1-1.7-1.1-3v-14.7h-5v16.5c.1 2 .8 3.6 2.1 4.8 1.3 1.2 3 1.9 5 1.9 1.9 0 3.7-.5 5.3-1.4 1.6-1 2.8-2.2 3.5-3.7l.3 4.3h4.5v-22.4zm22.1.1h-6.1V454h-5.1v9.9h-4.1v4h4.1v18.3h5.1v-18.3h6.1v-4zm40.6 3.1c0-3.6-.7-6.9-2.2-10-1.5-3.1-3.9-5.7-7.2-7.6-3.3-2-7.5-2.9-12.5-2.9h-11.9v39.7h13.8c3.6 0 7-.8 10-2.3 3-1.6 5.5-3.8 7.3-6.7 1.8-3 2.7-6.4 2.7-10.2zm37 19.2-17.9-41.3h-.4L359 486.2h7.7l3.2-7.8H383l3.1 7.8h9.1zm41.2-19.8c0-3.6-.9-7-2.8-10.1-1.9-3.1-4.3-5.6-7.5-7.5-3.1-1.9-6.5-2.8-10.1-2.8-3.6 0-7 .9-10.1 2.8-3.1 1.9-5.6 4.3-7.4 7.5-1.8 3.1-2.7 6.5-2.7 10.1 0 3.7.9 7.1 2.7 10.2 1.8 3.1 4.3 5.6 7.4 7.4 3.1 1.8 6.5 2.7 10.2 2.7 3.6 0 7-.9 10.1-2.7 3.1-1.8 5.6-4.3 7.5-7.4 1.8-3.2 2.7-6.6 2.7-10.2z"/><text x="50%" y="47%" class="base" fill="url(#c)" dominant-baseline="middle" text-anchor="middle" style="font-family:Josefin Sans,sans-serif;font-size:140px">';
    string constant initialSVGpart2 = '</text></svg>';

    IERC20 immutable EXPToken;

    constructor(
        string memory _name,
        string memory _symbol,
        address _EXPAdress
    ) ERC721(_name, _symbol) {
        EXPToken = IERC20(_EXPAdress);
    } 

    function mint() external {
        require(balanceOf(msg.sender) == 0, "one token per wallet");

        uint160 tokenId = uint160(msg.sender); 
        
        string memory initialSVG = string.concat(initialSVGpart1, "0", initialSVGpart2);
        
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"description": "An NFT showcasing EXP tokens of an individual", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(initialSVG)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(abi.encodePacked("data:application/json;base64,", json));
        
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, finalTokenUri);
    }

    //gets the EXP token balance of the address and updates the URI of the corresponding NFT
    function updateURI(address addressToUpdate) external {
        uint tokenId = uint160(addressToUpdate);

        string memory newTokenUri = URI.updateURI(addressToUpdate, address(EXPToken));
        
        _setTokenURI(tokenId, newTokenUri);
    }

    /*//////////////////////////////////////////////////////////////
                            SOULBOUND LOGIC
    //////////////////////////////////////////////////////////////*/

    //Disallowed for preventing gas waste
    function _approve(address to, uint256 tokenId) internal override {
        revert Soulbound();
    }

    //Disallowed for preventing gas waste
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal override {
        revert Soulbound();
    }

    //Only allows transfers if it is minting
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        if(from != address(0)) revert Soulbound();
    }
    
}