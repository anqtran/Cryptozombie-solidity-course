pragma solidity ^0.4.19;

import "./ownable.sol";

contract ZombieFactory is Ownable {

    event NewZombie(uint zombieId, string name, uint dna);

    // uint, default as uint256
    uint dnaDigits = 16;
    // 10 ^ dnaDigits
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        // keccak256 built in, which is a version of SHA3. 
        // A hash function basically maps an input string into a random 256-bit hexidecimal number. 
        // 64 characters
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }

}
