# Description 

Ethernaut Bounty.

An ERC20 token called EXP and an ERC721 token called EXPCounter which changes URI based on the number of EXP token address holds, both are Soulbound. NFT is one per wallet.
Corresponding NFT URI updates automatically when EXP tokens are minted or burned.

# Testing

`forge test`

# Scripts

`forge script --broadcast (path to file) --sig (function, example: "deploy()") --private-keys (your PK) --fork-url (rpc url) -vvvv`