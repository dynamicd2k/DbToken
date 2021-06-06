pragma solidity ^0.8.0;

/**
 * @title DbiliaToken
 * @dev Mint tokens with USD & ETH
 */

contract DbiliaToken {
    
    //Mapping user address to token count
    mapping (address => uint256) private _balances;
    
    //Mapping tokenId to user address
    mapping (uint256 => address) private _tokenIdOwner;
    uint256[] tokenIds;
    
    //Mapping tokenURI to user address
    mapping (string => address ) private _tokenOwner;
    
    //Mapping cardId to edition 
    mapping (string => string ) private _edition;
    
    uint256 tokenId;
    address dbilia;
    uint8 gasPaid=0;
    string tokenURI;
    address userId;
    
    event mintedWithUSD(address userId, string cardId, string edition, string tokenURI);
    
    event mintedWithETH(string cardId, string edition, string tokenURI);
    
    constructor(){
        dbilia=msg.sender;
    }
    
     /**
     * @dev function to confirm if gas fees is paid to Dbilia and trigger mintWithUSD
     * @param
     */
    function approveGasPayment() public returns(uint8){
        require(dbilia == msg.sender,"Only Dbilia owned account can approve gas payments.");
        gasPaid = 1;
        return 0;
    }
    
     /**
     * @dev function to set token URI once the token is minted
     * @param tokenId
     */
    function setTokenURI(uint256 tokenId) internal virtual returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");
        string memory baseURI = _baseURI();
        tokenURI= bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId)): '';
        return tokenURI;
    }
    
     /**
     * @dev function to mint tokens with USD
     * @param userID, cardID, edition
     */
    function mintWithUSD(address userId, string memory cardId, string memory edition) public virtual{
        require(dbilia == msg.sender,"Only Dbilia owned account can mint tokens with USD.");
        require(gasPaid==1, "Gas fees need to be paid in advance for USD minting");
        _balances[dbilia] +=1;
        tokenId=tokenId+1;
        tokenIds.push(tokenId);
        _tokenIdOwner[tokenId] = dbilia;
        tokenURI= setTokenURI(tokenId);
        _tokenOwner[tokenURI] = userId;
        gasPaid=0;
        emit mintedWithUSD(userId, cardId,edition, tokenURI);
    }
 
     /**
     * @dev function to mint tokens with ETH
     * @param cardId, edition
     */
    function mintWithETH(string memory cardId, string memory edition) public virtual{
        require(msg.sender!=dbilia, "User should directly call this function");
        require(msg.sender.balance>0, "User does not have enough ether");
        userId = msg.sender;
        _balances[msg.sender]= _balances[msg.sender] + 1;
        tokenId=tokenId+1;
        tokenIds.push(tokenId);
        _tokenIdOwner[tokenId] = userId;
        tokenURI= setTokenURI(tokenId);
        _tokenOwner[tokenURI] = userId;
        emit mintedWithETH(cardId, edition, tokenURI);
    }
    
    /**
     * @dev function to retrieve address token balance
     * @param tokenOwner address
     */
    function balanceOf(address tokenOwner) public view returns (uint) {
        require(tokenOwner != address(0), "Balance query for the zero address");
        return _balances[tokenOwner];
    }

     /**
     * @dev function to check if a token exists
     * @param tokenId
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _tokenIdOwner[tokenId] != address(0);
    }

     /**
     * @dev function to view Token Id Owner
     * @param tokenId
     */
    function viewTokenIdOwner(uint256 tokenId) public view returns(address){
        require(_exists(tokenId), "Token ID owner query for nonexistent token");
        return _tokenIdOwner[tokenId];
    }

     /**
     * @dev function to view Token URI Id Owner
     * @param tokenId
     */
    function viewTokenURIOwner(uint256 tokenId) public returns(address){
        require(_exists(tokenId), "Token URI owner query for nonexistent token");
        tokenURI= setTokenURI(tokenId);
        return _tokenOwner[tokenURI];
    }

     /**
     * @dev function to view all minted Tokens
     * @param
     */
    function viewTokens() public view returns(uint256[] memory){
        return tokenIds;
    }

    /**
     * @dev function to set BaseURI
     * @param
     */
     function _baseURI() internal view virtual returns (string memory) {
        return "";
    }
}