
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TodoList contract", function () {
  let TodoList;
  let todolist;
  let owner;

  before(async function () {
    [owner] = await ethers.getSigners();

    // Deploy the TodoList contract
    todolist = await ethers.deployContract("TodoList");
    // await TodoList.waitForDeployment();
  });

  it("should create a new task", async function () {
    const taskName = "Sample Task";
    const taskDescription = "This is a sample task description";

    // Create a new task
    await todolist.createTask(taskName, taskDescription);

    // Retrieve the task details
    const [id, date, name, description, isCompleted, taskOwner] =
      await todolist.getTask(0);

    expect(id).to.equal(0);
    expect(name).to.equal(taskName);
    expect(description).to.equal(taskDescription);
    expect(isCompleted).to.equal(false);
    expect(taskOwner).to.equal(owner.address);
  });

  it("should mark a task as completed", async function () {
    // Mark the task at index 0 as completed
    await todolist.markTaskCompleted(0);

    // Retrieve the task details
    const [, , , , isCompleted] = await todolist.getTask(0);

    expect(isCompleted).to.equal(true);
  });

  it("should delete a task", async function () {
    // Create a new task
    await todolist.createTask(
      "Task to be deleted",
      "This task will be deleted"
    );

    // Delete the task at index 1
    await todolist.deleteTask(1);

    // Attempt to retrieve the deleted task (should throw an error)
    let errorOccurred = false;
    try {
      await todolist.getTask(1);
    } catch (error) {
      errorOccurred = true;
    }

    expect(errorOccurred).to.equal(true);
  });

  it("should retrieve the user's tasks", async function () {
    // Create a new task
    await todolist.createTask("User's Task", "This is the user's task");

    // Retrieve the user's tasks
    const userTasks = await todolist.getUserTasks();

    // Expect that there is at least one task
    expect(userTasks.length).to.be.at.least(1);
  });
});
