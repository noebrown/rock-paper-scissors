// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/RockPaperScissors.sol";

contract ContractTest is Test {
    RockPaperScissors public rps; 

    address player1 = address(0x1);
    address player2 = address(0x2);

    function setUp() public {
        rps = new RockPaperScissors();
    }

    function testSucessfulCommit() public {
        bytes32 testCommitment = keccak256(
            abi.encodePacked(
                RockPaperScissors.MoveOption.Scissors, 
                bytes32("player1-secret-1")
            )
        );

        vm.startPrank(player1);
        rps.commitMove(testCommitment);
        vm.expectRevert("You can only submit one move.");
        rps.commitMove(testCommitment);

        (bytes32 commitment, RockPaperScissors.MoveOption revealedMove) = rps
            .gameMoves(player1);

        assertEq(testCommitment, commitment);
        assertEq(
            uint(revealedMove), 
            uint(RockPaperScissors.MoveOption.NotRevealedYet)
        );
        assertEq(rps.playerAddresses(0), player1);
    }

    function testSuccessfulReveal() public {
        vm.startPrank(player1);
        vm.expectRevert("No committed move to reveal.");
        rps.revealMove(
            RockPaperScissors.MoveOption.Scissors,
            bytes32("player1-secret")
        );

        bytes32 testCommitment = keccak256(
            abi.encodePacked(
                RockPaperScissors.MoveOption.Scissors, 
                bytes32("player1-secret")
            )
        );

        rps.commitMove(testCommitment);

        vm.expectRevert(
            "Both players must commit their moves before revealing."
        );

        rps.revealMove(
            RockPaperScissors.MoveOption.Scissors, 
            bytes32("player1-secret")
        );
        vm.stopPrank();

                vm.startPrank(player2);
        rps.commitMove(testCommitment);
        rps.revealMove(
            RockPaperScissors.MoveOption.Scissors,
            bytes32("player1-secret")
        );
        vm.stopPrank();

        vm.prank(player1);
        rps.revealMove(
            RockPaperScissors.MoveOption.Scissors,
            bytes32("player1-secret")
        );

        (bytes32 commitment, RockPaperScissors.MoveOption revealedMove) = rps.
            gameMoves(player1);
        
        assertEq(testCommitment, commitment);
        assertEq(
            uint(revealedMove), 
            uint(RockPaperScissors.MoveOption.Scissors)
        );
    }

    function testDetermineWinner() public{
        vm.expectRevert("Both players must commit their moves first");
        rps.determineWinner();

        bytes32 testCommitmentP1 = keccak256(
            abi.encodePacked(
                RockPaperScissors.MoveOption.Scissors,
                bytes32("player1-secret")
            )
        );

        vm.prank(player1);
        rps.commitMove(testCommitmentP1);

        vm.prank(player1);
        vm.expectRevert("You can only submit one move.");
        rps.commitMove(testCommitmentP1);

        vm.expectRevert("Both players must commit their moves first");
        rps.determineWinner();

        bytes32 testCommitmentP2 = keccak256(
            abi.encodePacked(
                RockPaperScissors.MoveOption.Rock,
                bytes32("player2-secret")
            )
        );

        vm.prank(player2);
        rps.commitMove(testCommitmentP2);

        vm.expectRevert("Both Players must reveal their moves first !");
        rps.determineWinner();

        vm.prank(player1);
        rps.revealMove(
            RockPaperScissors.MoveOption.Scissors,
            bytes32("player1-secret")
        );

        vm.expectRevert("Both Players must reveal their moves first !");
        rps.determineWinner();

        vm.prank(player2);
        vm.expectRevert("Wrong move or wrong pasword !");
        rps.revealMove(
            RockPaperScissors.MoveOption.Paper,
            bytes32("player2-secret")
        );

        vm.prank(player2);
        vm.expectRevert("Wrong move or wrong pasword !");
        rps.revealMove(
            RockPaperScissors.MoveOption.Rock,
            bytes32("wrong secret") 
        );

        vm.prank(player2);
        rps.revealMove(
            RockPaperScissors.MoveOption.Rock,
            bytes32("player2-secret")
        );

        address winner = rps.determineWinner();

        assertEq(rps.playerAddresses(0), address(player1));
        assertEq(rps.playerAddresses(1), address(player2));
        vm.expectRevert();
        assertEq(rps.playerAddresses(2), address(0x00));
        assertEq(winner, player2);
    }
}
