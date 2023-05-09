require("@nomiclabs/hardhat-waffle");

task("accounts" , "Prints the list of accounts" , async (taskArgs , hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});


/**
 * @type import('hardhat/config').HardhatUserConfig
 */

module.exports = {
  solidity: "0.8.2",
  networks: {
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: ["SET-private-key"]       // metamask private key
    }
  }
};
