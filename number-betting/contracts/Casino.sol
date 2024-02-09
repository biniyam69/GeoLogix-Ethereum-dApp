 pragma solidity 0.8.21;

 contract Casino {
    address public owner;
    uint256 public minimumBet;
    uint256 public totalBet;
    uint256 public numberOfBets;
    uint256 public maxAmountOfBets = 100;

    address[] public players;

    struct Player {
        uint256 amountBet;
	    uint256 numberSelected;
    }

    // address of the player mapped to the user info

    mapping(address => Player) public playerInfo;

    constructor (uint256 _minimumBet) {
        owner = msg.sender;
        if(_minimumBet != 0) minimumBet = _minimumBet;
    }

    function kill() public {
        if(msg.sender == owner) 
        selfdestruct(owner);
    }

    function checkPlayerExists(address player) returns(bool){
        for (uint i = 0; i < players.length; i++){
            if(players[i] == player) return true;
        }
        return false;
    }

    function bet(uint256 numberSelected) public payable {
        require(!checkPlayerExists(msg.sender));
	    require(numberSelected >= 1 && numberSelected <= 10);
	    require(msg.value >= minimumBet);

	    playerInfo[msg.sender].amountBet = msg.value;
	    playerInfo[msg.sender].numberSelected = numberSelected;
	    numberOfBets++;

	    players.push(msg.sender);
	    totalBet += msg.value;
        if(numberOfBets >= maxAmountOfBets) generateNumberWinner();
    }

    // Generates number between 1 and 10 that will be the winner

    function generateNumberWinner() public {
        uint256 numberGenerated = block.number % 10 + 1;
        distributePrizes(numberGenerated);
    }

    //sends ether to the winners

    function distributePrizes(uint256 numberWinner) public {
        address[100] memory winners; //Create an in memory array with a fixed size
        uint256 count = 0;

        for (uint256 i = 0; i < players.length; i++) {
            address playerAddress = players[i];
            if(playerInfo[playerAddress].numberSelected == numberWinner){
                winners[count] = playerAddress;
                count++;
            }
            delete playerInfo[playerAddress];
        }

        players.length = 0;

        uint256 winnerEtherAmount = totalBet / winners.length; // Each winner gets total bet devided by the length of the winner array

        for(uint256 j = 0; j < count; j++){
            if(winners[j] != address(0))
            winners[j].transfer(winnerEtherAmount);
        }
    }
}
