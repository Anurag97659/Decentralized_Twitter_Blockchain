// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract twitter{
    event tweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event tweetLiked(uint256 id, address author, address likedBy);
    event tweetUnliked(uint256 id, address author, address unlikedBy);
    address public owner;
    constructor(){
        owner = msg.sender;
    }
    // mapping(address=>string)tweets;
    //mapping basically means user = tweet, tweets belong to which user , its basically act as array address as index and valuse as tweet or value itself 
    //oviously one user can have more than one tweet so we are going to use array of string
    // mapping(address=>string[])tweets;
    // tweet has more data like date, author,likes so we are using struch rather than array of string
    struct Tweet{
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }
    mapping(address=>Tweet[])public tweets;
    function createtweet(string memory str)public onlyowner{
        require(bytes(str).length < 100, "Tweet is too long");
        Tweet memory newtweet =Tweet({
            id: tweets[msg.sender].length,
            author : msg.sender,
            content: str,
            timestamp:block.timestamp,
            likes:0
        });
        tweets[msg.sender].push(newtweet);
        emit tweetCreated(newtweet.id, newtweet.author, newtweet.content, newtweet.timestamp);
        // here msg and sender term belongs to blockchain, means msg is your id of blockchain account
    }
    function liketweet(address user, uint256 tweetid) external {
        require(tweets[user][tweetid].id == tweetid, "Tweet does not exist");
        tweets[user][tweetid].likes ++;
        emit tweetLiked(tweetid, user, msg.sender);
    }
    function unlikeTweet(address user, uint256 tweetid) external {
        require(tweets[user][tweetid].id == tweetid, "Tweet does not exist");
        require(tweets[user][tweetid].likes > 0, "No likes to remove");
        tweets[user][tweetid].likes --;
        emit tweetUnliked(tweetid, user, msg.sender);
    }
    function gettweet() public view returns(Tweet[] memory){
        return tweets[msg.sender]; 
    } 
    
    modifier onlyowner(){
        require(msg.sender == owner, "Not owner");
        _;
    }
    function changeowner(address newowner) public onlyowner{
        owner = newowner;
    }
}