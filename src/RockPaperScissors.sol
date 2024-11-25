// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract RockPaperScissors {
    constructor() {}

    enum MoveOption {
        NotRevealedYet,
        Rock,
        Paper, 
        Scissors
    }

    struct GameMove {
        bytes32 commitment;
        MoveOption revealedMove;
    }

    address[2] public playerAddresses;
    uint8 internal moveCount = 0;
    mapping(address => GameMove) public gameMoves;


    /** 
     * 1. Commit a move secretly (only user knows the move)
     * @param _commitment the move itself and a secret hashed together
     */
    function commitMove(bytes32 _commitment) public {
        require(moveCount < 2, "Too many game moves.");
        require(
            gameMoves[msg.sender].commitment == bytes32(0),
            "You can only submit one move."
        );

        gameMoves[msg.sender] = GameMove({
            commitment: _commitment,
            revealedMove: MoveOption.NotRevealedYet
        });

        playerAddresses[moveCount] = msg.sender;
        moveCount++;
    }

    /** 
     * 2. Reveal the move to public
     * @param _move The move the player originally submitted
     * @param _secret the secret provided as part of the commitment
     * compare orginal move and secret 
     */
    function revealMove(MoveOption _move, bytes32 _secret) public {
        require(
            gameMoves[msg.sender].commitment != bytes32(0),
            "No committed move to reveal."
        );
        require(
            moveCount == 2,
            "Both players must commit their moves before revealing."
        );

        bytes32 calculatedCommitement = keccak256(
            abi.encodePacked(_move, _secret)
        );

        require( 
            calculatedCommitement == gameMoves[msg.sender].commitment,
            "Wrong move or wrong pasword !"
        );

        gameMoves[msg.sender].revealedMove =_move;
    }

    /**
     * 3. Winner determined and revealed
     * Follows traditional Rock, Paper, Scissors rules
     * Returns players address
     */
    function determineWinner() public view returns (address winner) {
        require(
            moveCount == 2, 
            "Both players must commit their moves first"
        );

        address p1Address = playerAddresses[0];
        MoveOption p1Move = gameMoves[p1Address].revealedMove;

        address p2Address = playerAddresses[1];
        MoveOption p2Move = gameMoves[p2Address].revealedMove;

        require(
            (
                p1Move != MoveOption.NotRevealedYet && 
                p2Move != MoveOption.NotRevealedYet),
                "Both Players must reveal their moves first !"
        );

        // Draw: No One Wins
        if (p1Move == p2Move) {
            return address(0); 
        }

        // Scissors (P1)
        if (p1Move == MoveOption.Scissors) {
            // Paper (P2) - P1 WINS
            if (p2Move == MoveOption.Paper){
                return p1Address;
            }
            // Rock (P2)- P2 WINS
            if (p2Move == MoveOption.Rock){
                return p2Address;
            }
        }

        // Paper (P1)
        if (p1Move == MoveOption.Paper) {
            // Scissors (P2)- P2 WINS
            if (p2Move == MoveOption.Scissors){
                return p2Address;
            }
            // Rock (P2)- P1 WINS
            if (p2Move == MoveOption.Rock){
                return p1Address;
            }
        }

        // Rock (P1)
        if (p1Move == MoveOption.Rock) {
            // Scissors (P2)- P1 WINS
            if (p2Move == MoveOption.Scissors){
                return p1Address;
            }
            // Paper (P2)- P2 WINS
            if (p2Move == MoveOption.Paper){
                return p2Address;
            }
        }
    

    }
}