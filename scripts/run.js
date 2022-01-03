const { utils } = require("ethers");

async function main() {
    const baseTokenURI = "ipfs://QmTfMsae62x4C4kFXnXZqhcC7Pqd6r6MvQwkFycCpbhRDS/";

    // Get owner/deployer's wallet address
    const [owner] = await hre.ethers.getSigners();

    // Get contract that we want to deploy
    const contractFactory = await hre.ethers.getContractFactory("CoinCollection");

    // Deploy contract with the correct constructor arguments
    const contract = await contractFactory.deploy(baseTokenURI);

    // Wait for this transaction to be mined
    await contract.deployed();

    // Get contract address
    console.log("Contract deployed to:", contract.address);

    // Reserve NFTs
    let txn = await contract.reserve(20);
    await txn.wait();
    console.log("20 NFTs have been reserved");

    // Mint 3 NFTs by sending 0.03 ether
    txn = await contract.mint(1, { value: utils.parseEther('0.002') });
    await txn.wait()

    // Get all token IDs of the owner
    let tokens = await contract.tokensOf(owner.address)
    console.log("Owner has tokens: ", tokens);

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
});