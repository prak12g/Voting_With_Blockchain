// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract VotingSystem {
    enum ElectionState { NOT_STARTED, ONGOING, ENDED }

    struct Candidate {
        uint256 id;
        string name;
        string proposal;
        uint256 voteCount;
    }

    struct Voter {
        address delegate;
        bool hasVoted;
        uint256 vote;
        uint256 candidateId;
    }

    address admin;
    ElectionState electionState;

    mapping(address => Voter) voters;
    Candidate[] candidates;

    event ElectionStarted(address indexed owner);
    event ElectionEnded(address indexed owner);
    event CandidateAdded(uint256 id, string name, string proposal, address indexed owner, uint256 candidateCount);
    event VoteCast(address voter, uint256 candidateId, address indexed owner, uint256 voterCount);
    event VoteDelegated(address from, address to, address indexed owner);
    event VoterRegistered(address voter);
    event CandidateCount(uint256 candidateCount);
    event VoterCount(uint256 voterCount);
    event ElectionStateChecked(string state);
    event Results(uint256 id, string name, uint256 voteCount);
    
    modifier onlyAdmin(address _owner) {
        require(msg.sender == _owner, "Only admin can perform this action");
        _;
    }

    modifier onlyDuringElection() {
        require(electionState == ElectionState.ONGOING, "Election is not ongoing");
        _;
    }

    modifier onlyBeforeElection() {
        require(electionState == ElectionState.NOT_STARTED, "Election has already started");
        _;
    }

    constructor() {
        admin = msg.sender;
        electionState = ElectionState.NOT_STARTED;
    }

    function addCandidate(string memory _name, string memory _proposal, address _owner) public onlyAdmin(_owner) onlyBeforeElection {
        candidates.push(Candidate(candidates.length, _name, _proposal, 0));
        emit CandidateAdded(candidates.length - 1, _name, _proposal, _owner, candidates.length);
        emit CandidateCount(candidates.length);
    }

    function addVoter(address _voter, address _owner) public onlyAdmin(_owner) onlyBeforeElection {
        require(voters[_voter].delegate == address(0), "Voter already registered");
        emit VoterRegistered(_voter);
    }

    function startElection(address _admin) public onlyAdmin(_admin) onlyBeforeElection {
        require(_admin == admin, "Invalid admin address");
        electionState = ElectionState.ONGOING;
        emit ElectionStarted(_admin);
    }

    function endElection(address _admin) public onlyAdmin(_admin) onlyDuringElection {
        require(_admin == admin, "Invalid admin address");
        electionState = ElectionState.ENDED;
        emit ElectionEnded(_admin);
    }

    function vote(uint256 _candidateId, address _owner) public onlyDuringElection {
        require(!voters[msg.sender].hasVoted, "You have already voted");
        require(_candidateId < candidates.length, "Invalid candidate ID");

        voters[msg.sender].vote = _candidateId;
        voters[msg.sender].hasVoted = true;
        voters[msg.sender].candidateId = _candidateId;
        candidates[_candidateId].voteCount++;
        
        emit VoteCast(msg.sender, _candidateId, _owner, Voter_count());
        emit VoterCount(Voter_count());
    }

    function delegateVote(address _to, address _owner) public onlyDuringElection {
        require(!voters[msg.sender].hasVoted, "You have already voted");
        require(_to != msg.sender, "Self-delegation is not allowed");

        voters[msg.sender].delegate = _to;
        emit VoteDelegated(msg.sender, _to, _owner);
    }

    function checkState() public view returns (string memory) {
        return electionStateToString(electionState);
    }

    function electionStateToString(ElectionState _state) internal pure returns (string memory) {
        if (_state == ElectionState.NOT_STARTED) {
            return "NOT_STARTED";
        } else if (_state == ElectionState.ONGOING) {
            return "ONGOING";
        } else if (_state == ElectionState.ENDED) {
            return "ENDED";
        }
        // Should not reach here
        return "";
    }

    function candidate_count() public view returns (uint256) {
        return candidates.length;
    }

    function Voter_count() public view returns (uint256) {
        uint256 totalVoters = 0;
        for (uint256 i = 0; i < candidates.length; i++) {
            totalVoters += candidates[i].voteCount;
        }
        return totalVoters;
    }

    function showWinner() public view returns (uint256, string memory, uint256) {
        require(electionState == ElectionState.ENDED, "Election is not ended yet");

        uint256 winningVoteCount = 0;
        uint256 winningCandidateId = 0;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winningCandidateId = i;
            }
        }

        return (winningCandidateId, candidates[winningCandidateId].name, winningVoteCount);
    }

    function displayCandidate(uint256 _candidateId) public view returns (uint256 id, string memory name, string memory proposal) {
        require(_candidateId < candidates.length, "Invalid candidate ID");

        return (
            candidates[_candidateId].id,
            candidates[_candidateId].name,
            candidates[_candidateId].proposal
        );
    }

    function VoterProfile(address _voter) public view returns (uint256 votedTowards, uint256, address delegate , string memory Candidate_name ) {
        Voter memory voter = voters[_voter];
        string memory candidateName = candidates[voter.candidateId].name;
        return (voter.candidateId, voter.delegate != address(0) ? voters[voter.delegate].candidateId : 0, voter.delegate , candidateName);
    }
    
    function showResults(uint256 unit_id) public view returns (uint256 id, string memory name, uint256 votes) {
        require(unit_id < candidates.length, "Invalid candidate ID");
        Candidate memory candidate = candidates[unit_id];
        return (candidate.id, candidate.name, candidate.voteCount);
    }
    
    function getVoter(uint256 unit_id, address owner) public view returns (address voterAddress, address delegate) {
        require(unit_id < candidates.length, "Invalid candidate ID");
        Voter memory voter = voters[owner];
        return (owner, voter.delegate);
    }
}
