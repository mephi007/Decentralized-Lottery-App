/*
    Decentralised Lottery Application
    Entities=> Manager and participants
    atleast 3 participant has to participate to collect enough money.
    each participate will buy out entry for minimum of 1 eth. More than 1 eth will increase the no of entry for particular participant.

    Design=>
    Manager will have full control over the lottery.
    As participants will transfer ether, its address will be registered.
    Winner will get the total collected ether subtracted 20% comission to manager.
    The contract will reset once a round is completed.
*/


pragma solidity >=0.5.0 <0.9.0;

contract Lottery{

    //entites
    address public manager;
    address payable[] public participants;

    //to initialize the deploying account as manager
    constructor(){
        manager = payable(msg.sender);
    }
    
    //to receive the eth from participants.
    receive() external payable{
        //check the cost price of entry
        require(msg.value >= 1 ether);
        // uint value = msg.value;
        // uint entries =  value%1;
        // while(entries-- > 0){
        //     participants.push(payable(msg.sender));
            
        // }
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function getWinnerAddress() public view returns(address payable){
        uint randomNumber = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
        uint index = randomNumber%participants.length;
        return participants[index];
    }

    function selectWinner() public payable{
        require(msg.sender == manager);
        require(participants.length >= 3);
        address payable winner = getWinnerAddress();
        // uint total = getBalance();
        // uint comission = uint(total * 20/100);
        // uint prizeMoney = total - comission;
        winner.transfer(getBalance());
        // manager.transfer(comission);
        participants = new address payable[](0);
    }

    function noOfParticipants() public view returns(uint){
        return participants.length;
    }

}