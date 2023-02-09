// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// 众筹
contract CrowdFunding {
    address public immutable benficiary;
    uint256 public immutable fundingGoal;

    uint256 public fundingAmount;
    mapping(address => uint256) public funders;

    mapping(address=>bool) public fundersInserted;
    address[] public fundersKey;

    bool public AVALIABLE = true;

    constructor(address benficiary_, uint256 goal_) {
        benficiary = benficiary_;
        fundingGoal = goal_;
    }

    function contribute() external payable {
        require(AVALIABLE, "is closed");
        funders[msg.sender] +=msg.value;
        fundingAmount += msg.value;
        if(!fundersInserted[msg.sender]){
            fundersInserted[msg.sender] = true;
            fundersKey.push(msg.sender);
        }
    }

    function close() external returns(bool) {
        if(fundingAmount<fundingGoal){
            return false;
        }
        uint256 amout = fundingAmount;

        fundingAmount = 0;
        AVALIABLE = false;
        payable(benficiary).transfer(amout);


        return true;
    }
}
