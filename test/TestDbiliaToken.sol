pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "../contracts/DbiliaToken.sol";

/**
 * @title TestDbiliaToken
 * @dev Test contract DbiliaToken used to Mint tokens with USD & ETH
 */
contract TestDbiliaToken{

    uint8 gasPaid=0;

    /**
     * @dev function to test Gas payment approval function
     * @param
     */
    function testGasPayment() public{
        DbiliaToken Token = new DbiliaToken();
        Token.approveGasPayment();
        Assert.equal(msg.sender, '0xfDaff3aC7206a17A7ffb96470EC8cEB8A1edD5a7' ,'Only Dbilia owned account can approve gas payments');
        Assert.equal(Token.gasPaid, 1, "Gas needs to be pid in advance");
    }

    /**
     * @dev function to test mintWithUSD function
     * @param
     */
    function testMintWithUSD() public{
        DbiliaToken Token = new DbiliaToken();
        Token.mintWithUSD('0x0495BeC0eea88F0b474ba7F4eb5dBB653D4274a0', 'IC0011', '2020/01');
        Assert.equal(msg.sender, '0xfDaff3aC7206a17A7ffb96470EC8cEB8A1edD5a7', "Only Dbilia owned account can mint tokens with USD.");

        Assert.equal(Token._tokenOwner[Token.tokenURI], '0x0495BeC0eea88F0b474ba7F4eb5dBB653D4274a0', 'Token URI should be owned by the user');

        Assert.equal(Token._tokenIdOwner[Token.tokenId], '0xfDaff3aC7206a17A7ffb96470EC8cEB8A1edD5a7', 'Token will be owned by Dbilia if minted with USD');

    }

    /**
     * @dev function to test mintWithETH function
     * @param
     */
    function testMintWithETH() public {
        DbiliaToken Token = new DbiliaToken();
        Token.mintWithETH('IC0011','2020/01');
        Assert.notEqual(msg.sender, '0xfDaff3aC7206a17A7ffb96470EC8cEB8A1edD5a7', 'User should directly mint with ETH');

        Assert.equal(Token._tokenOwner[Token.tokenURI], '0xfDaff3aC7206a17A7ffb96470EC8cEB8A1edD5a7', 'Token URI should be owned by the user');

        Assert.equal(Token._tokenIdOwner[Token.tokenId], '0xfDaff3aC7206a17A7ffb96470EC8cEB8A1edD5a7', 'Token will be owned by Dbilia if minted with USD');

    }
}