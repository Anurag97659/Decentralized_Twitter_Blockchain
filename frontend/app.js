const CONTRACT_ADDRESS = "PASTE_YOUR_DEPLOYED_CONTRACT_ADDRESS_HERE";

const ABI = [
  "function createtweet(string str)",
  "function getAllTweets() view returns(tuple(uint256 id,address author,string content,uint256 timestamp,uint256 likes,address[] likedby)[])",
  "function likeTweet(address author,uint256 tweetid)",
  "function unlikeTweet(address author,uint256 tweetid)"
];

let provider, signer, contract, account;

document.getElementById("connectBtn").onclick = async () =>{
  if (!window.ethereum) return alert("Please install MetaMask");
  provider = new ethers.providers.Web3Provider(window.ethereum, "sepolia");
  await provider.send("eth_requestAccounts", []);
  signer = provider.getSigner();
  account = await signer.getAddress();
  contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);
  document.getElementById("account").innerText = "Connected: " + account;
  await loadTweets();
};


async function loadTweets(){
  if(!contract) return;
  try{
    const tweets = await contract.getAllTweets();
    const container = document.getElementById("tweetsContainer");
    container.innerHTML = "";

    if(tweets.length === 0){
      container.innerHTML = "<p class='text-gray-500 text-center'>No tweets yet</p>";
      return;
    }

    tweets.forEach(tweet =>{
      const div = document.createElement("div");
      div.className = "bg-gray-50 p-4 rounded shadow";

      const timestamp = new Date(tweet.timestamp * 1000).toLocaleString();

      div.innerHTML = `
        <p class="text-gray-700"><b>Author:</b> ${tweet.author}</p>
        <p class="my-2 text-gray-900">${tweet.content}</p>
        <p class="text-sm text-gray-500 mb-2">🕒 ${timestamp} | ❤️ Likes: ${tweet.likes}</p>
        <button onclick="likeTweet(${tweet.id}, '${tweet.author}')" class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded">Like</button>
        <button onclick="unlikeTweet(${tweet.id}, '${tweet.author}')" class="ml-2 bg-gray-500 hover:bg-gray-600 text-white px-3 py-1 rounded">Unlike</button>
      `;
      container.appendChild(div);
    });
  }
  catch (err){
    console.error("Load tweets failed:", err);
  }
}

document.getElementById("tweetBtn").onclick = async () =>{
  const content = document.getElementById("tweetContent").value.trim();
  if(!content) return alert("Tweet cannot be empty");

  try{
    const tx = await contract.createtweet(content);
    await tx.wait();
    document.getElementById("tweetContent").value = "";
    await loadTweets();
  }
  catch(err){
    console.error("Create tweet failed:", err);
    alert("Transaction failed. Make sure you are on Sepolia and have test ETH.");
  }
};


async function likeTweet(id, author){
  try{
    const tx = await contract.likeTweet(author, id);
    await tx.wait();
    await loadTweets();
  }
  catch(err){
    console.error("Like failed:", err);
    alert("Transaction failed");
  }
}

async function unlikeTweet(id, author){
  try{
    const tx = await contract.unlikeTweet(author, id);
    await tx.wait();
    await loadTweets();
  } 
  catch (err) {
    console.error("Unlike failed:", err);
    alert("Transaction failed");
  }
}
