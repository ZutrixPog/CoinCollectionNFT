//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract CoinCollection is ERC721Enumerable, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    uint public constant MAX_SUPPLY = 10000;
    uint public constant PRICE = 0.001 ether;
    uint public constant MAX_PER_MINT = 10;

    Counters.Counter private _tokens;
    mapping(uint => string) private _nftNames;
    string private baseTokenURI;

    modifier isEnoughNft(uint _amount) {
        require(_tokens.current().add(_amount) < MAX_SUPPLY, "Not enough nfts remaining!");
        _;
    }

    constructor(string memory _base_url) ERC721("Crypto Coins Collection", "COINS") {
        baseTokenURI = _base_url;
    }

    function setBaseUrl(string memory _base_url) external onlyOwner() {
        baseTokenURI = _base_url;
    }

    function _baseURI() internal 
                    view 
                    virtual 
                    override 
                    returns (string memory) {
     return baseTokenURI;
}

    function reserve(uint _amount) external onlyOwner() isEnoughNft(_amount) {
        for (uint i = 0; i < _amount; i++) {
            _mint();
        }
    }

    function mint(uint _amount) external payable isEnoughNft(_amount) {
        require(_amount > 0 && _amount <= MAX_PER_MINT, "You can only mint 10 items!");
        require(_amount.mul(PRICE) <= msg.value, "Not enough ether to buy our NFT!");

        for (uint i = 0; i < _amount; i++) {
            _mint();
        }
    }

    function nameNft(uint _token, string memory _name) external {
        uint token = tokenOfOwnerByIndex(msg.sender, _token);
        require(token != 0, "Not found");
        _nftNames[token] = _name;
    }

    function getNftName(uint _token) external view returns(string memory) {
        return _nftNames[_token];
    }

    function tokensOf(address _owner) external view returns(uint[] memory) {
        uint count = balanceOf(_owner);
        uint[] memory tokens = new uint[](count);

        for (uint i = 0; i < count; i++) {
            tokens[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokens;
    }

    function _mint() private isEnoughNft(1) {
        uint newId = _tokens.current();
        _safeMint(msg.sender, newId);
        _tokens.increment();
    }
}
