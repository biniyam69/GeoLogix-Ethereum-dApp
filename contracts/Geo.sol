// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;


contract RefundByLocation {
    address public creator;
    
    struct Device {
        uint latitude;
        uint longitude;
        uint timestamp;
        bool isCompliant;
    }
    
    mapping(address => Device) public devices;
    
    event DeviceAdded(address indexed device, uint latitude, uint longitude, uint timestamp);
    event ComplianceChecked(address indexed device, bool isCompliant);
    
    modifier onlyCreator() {
        require(msg.sender == creator, "Only creator can call this function");
        _;
    }
    
    constructor() {
        creator = msg.sender;
    }
    
    function addDevice(address _device, uint _latitude, uint _longitude, uint _timestamp) external onlyCreator {
        devices[_device] = Device(_latitude, _longitude, _timestamp, true);
        emit DeviceAdded(_device, _latitude, _longitude, _timestamp);
    }
    
    function updateLocation(uint _latitude, uint _longitude, uint _timestamp) external {
        require(devices[msg.sender].isCompliant, "Device not registered or already non-compliant");
        devices[msg.sender].latitude = _latitude;
        devices[msg.sender].longitude = _longitude;
        devices[msg.sender].timestamp = _timestamp;
        checkCompliance(msg.sender);
    }
    
    function checkCompliance(address _device) internal {
        // Implement compliance check based on location rules
        bool compliant = true; // Placeholder, implement your compliance logic
        devices[_device].isCompliant = compliant;
        emit ComplianceChecked(_device, compliant);
    }
    
    function refund() external {
        require(!devices[msg.sender].isCompliant, "Device is compliant");
        // Implement refund logic
        // Transfer funds to device account
    }
    
    function withdrawFunds() external onlyCreator {
        // Implement withdrawal of funds by the creator
    }
}

