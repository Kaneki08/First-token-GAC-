//SPDX-License-Identifier: TKN
pragma solidity >=0.4.0 <0.10.0;

contract GAC{
    

    //talk about events here
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval (address indexed tokenOwner, address indexed receiver, uint tokens);

    string public constant name = "GatitoCoin";
    string public constant symbol = "GAC";
    uint public decimal = 18;

    //Mapping {key:value}
    //addres:10000 GAC
    mapping(address => uint) balances;

    //map
    //{0x0: {0x1{some one else: 100 MOC}
    mapping(address => mapping(address =>uint)) allowedTransactions;

    //suply
    uint _totalSupply;

    constructor(uint inputValue){
        _totalSupply = inputValue;
        //msg.sender => your metamask address
        balances[msg.sender] = _totalSupply;
    }
    //first requiere function 
    function viewTotalSupply() public view returns (uint){
        return _totalSupply;
    }
    // second requiered function 
    function balanceOf(address owner) public view returns(uint){
        return balances[owner];
    }
    // challenge
// function transfer(address recipient, uint amount) public returns (bool){
//         if (balanceOf(msg.sender) >= amount) {
//             balances[recipient] += amount;
//             balances[msg.sender] -= amount;
//             return true;
//         }
//         else {
//             return false;
//         }
//     }
//         function transferFrom(address sender, address recipient, uint amount) public returns (bool){
//                 if (balanceOf(sender) >= amount) {
//                     balances[recipient] += amount;
//                     balances[sender] -= amount;
//                     return true;
//                 }
//                 else {
//                     return false;
//                 }
//             }

// better option 
    
function transfer(address receiver, uint numOfTokens) public returns (bool){
   //strictly say if we have enough tokens
   //SEDDING tokens to your address to yours
    require(numOfTokens<= balances[msg.sender],'Insufficient Funds');
    //remove the number of tokes from balances
    balances[msg.sender] -= numOfTokens;
    // send the num of token to the other user
    balances[receiver] += numOfTokens;
    //here is where our event funtion is emmited, we are calling it
    // help us verify the transaction 
    emit Transfer(msg.sender, receiver, numOfTokens);
    return true;
}
function approve(address receiver , uint numOfTokens) public returns (bool){
    //populate allowed transaction
    allowedTransactions[msg.sender][receiver] = numOfTokens;
    // emit our aprroval
    emit Approval(msg.sender, receiver, numOfTokens);
    return true;

}

    function allowence(address owner, address otherAccount ) public view returns(uint) {
        return allowedTransactions[owner][otherAccount];
    }

    function transferFrom(address owner, address otherAccount, uint numOfTokens) public returns(bool){
        //set a check using require
        require(numOfTokens <= balances[owner]);
        //we want to do another,
        //Allowed 
        require(numOfTokens <= allowedTransactions[owner][otherAccount]);
        balances[owner] -= numOfTokens;
        // send money from account to account
        allowedTransactions[owner][msg.sender]-= numOfTokens;
        balances[otherAccount] += numOfTokens;
        emit Transfer(owner, otherAccount, numOfTokens);
        return true;
    }

}
