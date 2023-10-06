// SPDX-License-Identifier: MIT

// Solidity Version
pragma solidity 0.8.19;

contract TodoList {
    // Struct to represent a task
    struct Task {
        uint id; // Unique task identifier
        uint date; // Timestamp of task creation
        string name; // Task name
        string description; // Task description
        bool isCompleted; // Flag indicating task completion status
        address owner; // Address of the task owner
    }

    // Array to store all tasks
    Task[] public tasks;

    // Mapping to associate user addresses with their task IDs
    mapping(address => uint[]) private userTasks;

    // Constructor function
    constructor() {}

    // Event emitted when a task is created
    event TaskCreated(
        uint id,
        uint date,
        string name,
        string description,
        bool isCompleted,
        address owner
    );

    // Event emitted when a task is marked as completed
    event TaskCompleted(uint id, address owner);

    // Event emitted when a task is deleted
    event TaskDeleted(uint id, address owner);

    // Function to create a new task
    function createTask(string memory name, string memory description) public {
        uint taskId = tasks.length; // Calculate the new task ID
        tasks.push(
            Task(taskId, block.timestamp, name, description, false, msg.sender)
        ); // Create and add the new task to the array
        userTasks[msg.sender].push(taskId); // Update the userTasks mapping
        emit TaskCreated(
            taskId,
            block.timestamp,
            name,
            description,
            false,
            msg.sender
        ); // Emit a TaskCreated event
    }

    // Function to retrieve task details by ID
    function getTask(
        uint id
    )
        public
        view
        returns (uint, uint, string memory, string memory, bool, address)
    {
        require(id < tasks.length, "Task ID does not exist"); // Ensure the task ID is valid
        Task storage task = tasks[id]; // Retrieve the task from storage
        return (
            task.id,
            task.date,
            task.name,
            task.description,
            task.isCompleted,
            task.owner
        ); // Return task details
    }

    // Function to mark a task as completed
    function markTaskCompleted(uint id) public {
        require(id < tasks.length, "Task ID does not exist"); // Ensure the task ID is valid
        Task storage task = tasks[id]; // Retrieve the task from storage
        require(
            task.owner == msg.sender,
            "Only the owner can complete the task"
        ); // Ensure only the owner can complete the task
        require(!task.isCompleted, "Task is already completed"); // Ensure the task is not already completed
        task.isCompleted = true; // Mark the task as completed
        emit TaskCompleted(id, msg.sender); // Emit a TaskCompleted event
    }

    // Function to delete a task
    function deleteTask(uint id) public {
        require(id < tasks.length, "Task ID does not exist"); // Ensure the task ID is valid
        Task storage task = tasks[id]; // Retrieve the task from storage
        require(task.owner == msg.sender, "Only the owner can delete the task"); // Ensure only the owner can delete the task
        emit TaskDeleted(id, msg.sender); // Emit a TaskDeleted event

        // Delete the task by replacing it with the last task in the array and reducing the array size
        uint lastIndex = tasks.length - 1;
        if (id != lastIndex) {
            Task storage lastTask = tasks[lastIndex];
            tasks[id] = lastTask;
            userTasks[msg.sender][id] = lastIndex;
        }
        tasks.pop();
        userTasks[msg.sender].pop();
    }

    // Function to retrieve all task IDs belonging to the caller
    function getUserTasks() public view returns (uint[] memory) {
        return userTasks[msg.sender]; // Return the task IDs associated with the caller's address
    }
}
