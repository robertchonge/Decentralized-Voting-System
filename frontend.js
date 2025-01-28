
const contractAddress = 'CONTRACT_ADDRESS'; // will replace with actual contract address
const contractABI = [...] // will replace with actual ABI from the compiled contract

const web3 = new Web3(window.ethereum);
let contract = new web3.eth.Contract(contractABI, contractAddress);

async function voteForCandidate(candidate) {
    const accounts = await web3.eth.getAccounts();
    contract.methods.vote(candidate).send({ from: accounts[0] })
        .then(() => {
            console.log('Vote successfully casted');
        })
        .catch(err => {
            console.log('Error casting vote:', err);
        });
}

async function getCandidates() {
    contract.methods.getCandidates().call()
        .then((candidates) => {
            console.log('Candidates:', candidates);
        })
        .catch(err => {
            console.log('Error fetching candidates:', err);
        });
}

async function closeVoting() {
    const accounts = await web3.eth.getAccounts();
    contract.methods.closeVoting().send({ from: accounts[0] })
        .then(() => {
            console.log('Voting has been closed');
        })
        .catch(err => {
            console.log('Error closing voting:', err);
        });
}
