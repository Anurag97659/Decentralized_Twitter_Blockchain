// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract twitter_ {
    event tweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event tweetLiked(uint256 id, address author, address likedBy);
    event tweetUnliked(uint256 id, address author, address unlikedBy);

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
        address[] likedby;
    }

    mapping(address => Tweet[]) private tweets;

    Tweet[] public allTweets;

    address[] private users;

    function createtweet(string memory str) public {
        require(bytes(str).length < 100, "Tweet is too long");

        if (tweets[msg.sender].length == 0) {
            users.push(msg.sender);
        }

        Tweet memory newtweet = Tweet({
            id: tweets[msg.sender].length + 1,
            author: msg.sender,
            content: str,
            timestamp: block.timestamp,
            likes: 0,
            likedby:new address[](0)
        });

        tweets[msg.sender].push(newtweet);
        allTweets.push(newtweet);

        emit tweetCreated(newtweet.id, newtweet.author, newtweet.content, newtweet.timestamp);
    }

    function gettweet() public view returns (Tweet[] memory) {
        return tweets[msg.sender];
    }

    function getAllTweets() public view returns (Tweet[] memory) {
        return allTweets;
    }

    modifier onlyowner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function changeowner(address newowner) public onlyowner {
        owner = newowner;
    }

    function likeTweet(address author, uint256 tweetid) external {
        Tweet[] storage authorTweets = tweets[author];
        for (uint256 i = 0; i < authorTweets.length; i++) {
            if (authorTweets[i].id == tweetid) {
                for (uint256 j = 0; j < authorTweets[i].likedby.length; j++) {
                    require(authorTweets[i].likedby[j] != msg.sender, "Already liked");
                }
                authorTweets[i].likes += 1;
                authorTweets[i].likedby.push(msg.sender);
                emit tweetLiked(tweetid, author, msg.sender);
                return;
            }
        }
        revert("Tweet not found");
    }

    function unlikeTweet(address author, uint256 tweetid) external {
        Tweet[] storage authorTweets = tweets[author];
        for (uint256 i = 0; i < authorTweets.length; i++) {
            if (authorTweets[i].id == tweetid) {
                bool found = false;
                for (uint256 j = 0; j < authorTweets[i].likedby.length; j++) {
                    if (authorTweets[i].likedby[j] == msg.sender) {
                        authorTweets[i].likedby[j] = authorTweets[i].likedby[authorTweets[i].likedby.length - 1];
                        authorTweets[i].likedby.pop();
                        found = true;
                        emit tweetUnliked(tweetid, author, msg.sender);
                        break;
                    }
                }
                require(found, "You have not liked this tweet");
                authorTweets[i].likes -= 1;
                return;
            }
        }
        revert("Tweet not found");
    }
}
