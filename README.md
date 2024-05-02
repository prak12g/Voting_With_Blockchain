# Voting_With_Blockchain
The VotingSystem contract facilitates the administration and execution of a voting process. Here's a breakdown of its features:
Enum ElectionState: Defines the possible states of the election: NOT_STARTED, ONGOING, and ENDED.
#Structs:
1.	Candidate: Represents a candidate participating in the election. It includes fields for id, name, proposal, and voteCount.
2.	Voter: Represents a voter in the election. It includes fields for delegate, hasVoted, vote, and candidateId.
#State Variables:
1.	admin: Stores the address of the administrator who manages the election process.
2.	electionState: Tracks the current state of the election.
3.	candidates: An array to store information about all the candidates.
4.	voters: A mapping to store information about registered voters.
#Events:
1.	ElectionStarted: Fired when the election is started.
2.	ElectionEnded: Fired when the election is ended.
3.	CandidateAdded: Fired when a new candidate is added to the election.
4.	VoteCast: Fired when a voter casts a vote.
5.	VoteDelegated: Fired when a voter delegates their voting right to another address.
6.	VoterRegistered: Fired when a new voter is registered.
7.	CandidateCount: Fired when the count of candidates is updated.
8.	VoterCount: Fired when the count of voters is updated.
9.	ElectionStateChecked: Fired when the current state of the election is checked.
10.	Results: Fired to display the results of the election.
#Modifiers:
1.	onlyAdmin: Restricts access to functions only to the admin address.
2.	onlyDuringElection: Restricts access to functions only during the ongoing election.
3.	onlyBeforeElection: Restricts access to functions only before the election starts.
#Constructor:
1.	Initializes the admin and sets the electionState to NOT_STARTED upon deployment.
#Public Functions:
1.	addCandidate: Allows the admin to add a new candidate before the election starts.
2.	addVoter: Allows the admin to register a new voter before the election starts.
3.	startElection: Allows the admin to start the election.
4.	endElection: Allows the admin to end the ongoing election.
5.	vote: Allows voters to cast their votes during the ongoing election.
6.	delegateVote: Allows voters to delegate their voting rights to another address during the ongoing election.
7.	checkState: Allows anyone to check the current state of the election.
8.	candidate_count: Returns the total number of candidates.
9.	Voter_count: Returns the total number of votes casted.
10.	showWinner: Returns the details of the winning candidate after the election ends.
11.	displayCandidate: Returns the details of a specific candidate.
12.	VoterProfile: Returns the profile of a voter, including the candidate they voted for.
13.	showResults: Returns the results of the election for a specific candidate.
14.	getVoter: Returns the address of a voter and their delegate.
    
#The contract provides functionalities for initializing the election, registering candidates and voters, casting and delegating votes, and obtaining #election results. It ensures that certain actions are only performed by the admin and within the appropriate stages of the election process.

