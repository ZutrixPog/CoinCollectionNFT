const { utils } = require("ethers");
const {abi} = require('../artifacts/contracts/CoinCollection.sol/CoinCollection.json');

async function main() {
    const signers = await hre.ethers.getSigners();
    //const CoinCollection = new hre.ethers.Contract("0x270eb8c0Ba6F44A703732bAABe2A0dc83D06E33f", abi, provider);
    const contract = await hre.ethers.getContractAt("CoinCollection", "0x270eb8c0Ba6F44A703732bAABe2A0dc83D06E33f", signers[0])

    let txn = await contract.mint(5, {value: utils.parseEther("0.006")});
    await txn.wait();
    console.log("5 NFTs have been minted");

    let tokens = await contract.tokensOf(signers[0]);
    console.log("Owner has tokens: ", tokens);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
});