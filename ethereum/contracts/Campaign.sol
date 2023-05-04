pragma solidity ^0.4.17;

contract CampaignFactory {
    address[] public deployedCampaigns;

    // expect to pass in the mimimum contribution to create a campaign
    function createCampaign(uint minimum) public {
        // I am still having trouble understanding this code. When you create a new instane of a contract, do you automatically get the address of that Campaign returned?
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }
}

contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }

    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;

    // conventionally we place any modifier before the constructor function
    modifier restricted() {
        require(msg.sender == manager);
        // this looks a bit weird, but it implies that whereever this require function is called, the rest of the function will be called after that
        _;
    }

    // Constructor function
    function Campaign(uint minimum, address creator) public {
        manager = creator;
        minimumContribution = minimum;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);
        // assigning "true" to the address that happens to be a contributor, as a "mapping". But beware that msg.sender is not stored to the mapping, only 'true' is.　So it is quite different from a "hash".
        approvers[msg.sender] = true;
        approversCount++;
    }

    function createRequest(
        string description,
        uint value,
        address recipient
    ) public restricted {
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            approvalCount: 0
            // don't have to intialize "reference types", only initialize "value types" so no need to care about initializing "mapping (address => bool) approvals"
        });

        requests.push(newRequest);
    }

    function approveRequest(uint index) public {
        Request storage request = requests[index];

        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];

        // this requires the total number of approvals are greater than 50% of the total number of approvers
        require(request.approvalCount > (approversCount / 2));

        require(!request.complete);

        // transfer ether to the recepient
        request.recipient.transfer(request.value);

        request.complete = true;
    }
}
