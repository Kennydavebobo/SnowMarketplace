const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Marketplace", function () {
  let marketplace;
  let owner, buyer;

  before(async function () {
    [owner, buyer] = await ethers.getSigners();
    const Marketplace = await ethers.getContractFactory("Marketplace");
    marketplace = await Marketplace.deploy();
    await marketplace.deployed();
  });

  it("Should list an item", async function () {
    await marketplace.listItem(ethers.utils.parseEther("1"));
    const item = await marketplace.getItem(1);
    expect(item[2].toString()).to.equal(
      ethers.utils.parseEther("1").toString()
    );
  });

  it("Should allow an item to be purchased", async function () {
    const itemPrice = ethers.utils.parseEther("1");
    await marketplace.connect(buyer).buyItem(1, { value: itemPrice });
    const item = await marketplace.getItem(1);
    expect(item[3]).to.equal(true);
  });
});
