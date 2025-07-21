
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedVoting {
    address public owner;
    mapping(address => bool) public voters;
    mapping(string => uint) public votes;
    string[] public candidates;
    bool public votingOpen;
    uint public totalVotes;

    event Voted(address indexed voter, string candidate);
    event VotingClosed();
    event CandidateAdded(string candidate);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier hasNotVoted() {
        require(!voters[msg.sender], "You have already voted");
        _;
    }

    modifier votingIsOpen() {
        require(votingOpen, "Voting is closed");
        _;
    }

    modifier validCandidate(string memory _candidate) {
        bool valid = false;
        for (uint i = 0; i < candidates.length; i++) {
            if (keccak256(abi.encodePacked(candidates[i])) == keccak256(abi.encodePacked(_candidate))) {
                valid = true;
                break;
            }
        }
        require(valid, "Invalid candidate");
        _;
    }

    constructor(string[] memory _candidates) {
        owner = msg.sender;
        candidates = _candidates;
        votingOpen = true;
        totalVotes = 0;
    }

    function vote(string memory _candidate) public hasNotVoted votingIsOpen validCandidate(_candidate) {
        votes[_candidate]++;
        voters[msg.sender] = true;
        totalVotes++;
        emit Voted(msg.sender, _candidate);
    }

    function closeVoting() public onlyOwner {
        votingOpen = false;
        emit VotingClosed();
    }

    function addCandidate(string memory _candidate) public onlyOwner {
        candidates.push(_candidate);
        emit CandidateAdded(_candidate);
    }

    function getVoteCount(string memory _candidate) public view returns (uint) {
        return votes[_candidate];
    }

    function getCandidates() public view returns (string[] memory) {
        return candidates;
    }

    function getTotalVotes() public view returns (uint) {
        return totalVotes;
    }
}
