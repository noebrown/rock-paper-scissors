# Rock-Paper-Scissors
The development of this smart contract follows a [tutorial](https://www.youtube.com/watch?v=hJr3v-ZtkOk&t=4128s). This projected allowed me to further develop on my smart contract development skills and taught me the commit-reveal scheme (often used in smart contract development). I used [Foundry](https://github.com/foundry-rs/foundry) as the devlopment environment and wrote smart contract tests in this project.

## Getting Started

This repo uses [Foundry](https://github.com/foundry-rs/foundry) as the development environment. Starting the project locally:
1. [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) the repository.

2. [Install Foundry](https://book.getfoundry.sh/getting-started/installation):

    ```bash
    curl -L https://foundry.paradigm.xyz | bash
    ```

3. Build and test the smart contracts:
    
    ```bash
    foundry test
    ```

## Logic behind the Smart Contract
The `RockPaperScissors.sol` smart contract allows two players to play a single game of rock-paper-scissors using the commit-reveal scheme. The logic of the game can be described in three steps.

**Step 1: Commit**

> Players commit to their move (rock, paper, or scissors) and a secret phrase. The move and secret phrase are hashed together.

**Step 2: Reveal**

> Players reveal their move by providing the same move and secret phrase used in the commit step. The smart contract compares the hash submitted in the commit step and the new hash computed in the reveal step to see if they match. If the hashes are the same the move will be revealed.

**Step 3: Determine the Winner**

> Once both players have revealed their moves, the smart contract determines the winner. The normal rules of rock paper scissors are used to determine the winner (rock beats scissors, scissors beats paper, and paper beats rock).
