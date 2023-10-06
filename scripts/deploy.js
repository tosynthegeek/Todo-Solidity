// Import the ethers library from the Hardhat framework
const { ethers } = require("hardhat");

// Define an asynchronous main function for contract deployment
async function main() {
  // Deploy the contract
  const TodoList = await ethers.deployContract("TodoList");

  // Log message to show deployment in progress
  console.log("Deploying contract.....");

  // Wait for the deployment of the contract to complete
  await TodoList.waitForDeployment();

  // Log the deployment target (contract address) to the console
  console.log(`TodoList deployed to ${TodoList.target}`);
}

// Execute the main function, and handle any errors that may occur
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});



