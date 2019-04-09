pragma solidity ^0.5.7;
// pragma experimental ABIEncoderV2;

/**
 * @title EbakusDB
 * @dev Library for giving access to EbakusDB.
 */
library EbakusDB {
  event Log(uint _value);
  event LogBytes(bytes _value);
  event LogBytes1(bytes1 _value);
  event LogBytes32(bytes32 _value);
  event LogBytes32Arr(bytes32[] _value);
  event LogBytes4(bytes4 _bytes4);
  event LogBool(bool _value);

  // createTable(tableName, ...indexes)
  // select(tableName, index, prefix)
  // insertObj(tableName, obj)
  // deleteObj(tableName, id)
  // next()???
  // prev()???

  /**
    * @dev Get some data.
    */
  function get(uint256 amount) internal returns(uint256 o) {
    uint256[1] memory input;
    input[0] = amount;
    emit Log(amount);

    assembly {
      let p := mload(0x40)
      if iszero(call(not(0), 0x102, 0, input, 0x20, p, 0x20)) {
        revert(0, 0)
      }
      o := mload(p)
    }
  }

  function set(uint256 amount) internal returns (uint256 o){
    bytes4 sig = bytes4(keccak256("get(uint64)")); // Function signature

    assembly {
      let x := mload(0x40)   // Find empty storage location using "free memory pointer"
      mstore(x, sig) // Place signature at begining of empty storage
      mstore(add(x, 0x04), amount) // Place first argument directly next to signature

      let success := call(        // This is the critical change (Pop the top stack value)
                          not(0), // 5k gas
                          0x102,  // To addr
                          0,      // No value
                          x,      // Inputs are stored at location x
                          0x24,   // Inputs are 36 bytes long
                          x,      // Store output over input (saves space)
                          0x20)   // Outputs are 32 bytes long

      o := mload(x) //Assign output value to c
      mstore(0x40, add(x, 0x24)) // Set storage pointer to empty space
    }
  }

  function forStructWorking() internal returns (bytes memory o) {
    bytes4 sig = bytes4(keccak256("forStruct()")); // Function signature

    assembly {
      let x := mload(0x40)   // Find empty storage location using "free memory pointer"
      mstore(x, sig) // Place signature at begining of empty storage

      let success := call(        // This is the critical change (Pop the top stack value)
                          not(0), // 5k gas
                          0x102,  // To addr
                          0,      // No value
                          x,      // Inputs are stored at location x
                          0x04,   // Inputs are 36 bytes long
                          x,      // Store output over input (saves space)
                          0x40)   // Outputs are 32 bytes long

      // gas fiddling
      switch success case 0 {
        revert(0, 0)
      }

      mstore(o, 0x40) //Assign output value to c
      mstore(add(o, 0x20), mload(add(x, 0x00)))
      mstore(add(o, 0x40), mload(add(x, 0x20)))
      mstore(0x40, add(x, 0x60)) // Set storage pointer to empty space
    }
    emit LogBytes(o);
  }

  function forStruct() internal returns (bytes memory o) {
    bytes4 sig = bytes4(keccak256("forStruct()")); // Function signature

    // o = new bytes(64);
    emit LogBytes(o);

    assembly {
      // function allocate(length) -> pos {
      //   pos := mload(0x40)
      //   mstore(0x40, add(pos, length))
      // }

      let x := mload(0x40)   // Find empty storage location using "free memory pointer"
      mstore(x, sig) // Place signature at begining of empty storage

      let success := call(        // This is the critical change (Pop the top stack value)
                          not(0), // 5k gas
                          0x102,  // To addr
                          0,      // No value
                          x,      // Inputs are stored at location x
                          0x04,   // Inputs are 36 bytes long
                          o,      // Store output over input (saves space)
                          0xffff)   // Outputs are 32 bytes long

      // gas fiddling
      switch success case 0 {
        revert(0, 0)
      }

      let size := mload(o)

      mstore(0x40, add(x, add(size, 0x20))) // Set storage pointer to empty space
    }
    emit LogBytes(o);
  }

  // createTable(tableName, ...indexes)
  function createTable(string memory tableName, string memory indexes) internal returns (bool o) {
    // string memory sigS = "createTable(string,string)";
    // string memory sigS = "createTable(string,string[])";

    // bytes4 sig = bytes4(keccak256("createTable(string,string)"));
    // // bytes memory abi = abi.encode(tableName, indexes); // indexes[0]);

    // bytes memory abi = abi.encodeWithSelector(sig, tableName, indexes); // indexes[0]);


    bytes memory input = abi.encodeWithSignature("createTable(string,string)", tableName, indexes); // indexes[0]);

    // emit LogBytes4(sig);
    // emit LogBytes(abi);

    assembly {
      let size := mload(input)
      let x := add(input, 0x20)

      if iszero(call(not(0), 0x102, 0, x, size, x, 0xffff)) {
        revert(0, 0)
      }
      o := mload(x)
    }
  }

  // it currently fails because of string[], we can try with bytes[]
  // https://github.com/acloudfan/Blockchain-Course-Basic-Solidity/blob/master/contracts/SpecialArrays.sol#L25
  // function createTable(string memory tableName, string[] memory indexes) internal returns (bool o) {
  //   bytes4 sig = bytes4(keccak256("createTable(string,string)"));
  //   bytes memory input = abi.encode(tableName, "Name"); // indexes[0]);

  //   // bytes memory abi = abi.encodeWithSelector(sig, tableName, indexes); // indexes[0]);
  //   // bytes memory input = abi.encodeWithSignature("createTable(string,string[])", tableName, indexes);

  //   // TODO: loop indexes and abi.encode all of them + append to input with array size

  //   // emit LogBytes(input);

  //   // cmd=createTable "[252 139 74 223]"
  //   // 0xfc8b4adf00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000b546573744578616d706c6500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044e616d6500000000000000000000000000000000000000000000000000000000

  //   uint256 size = 4 + input.length;
  //   emit Log(size);

  //   // bytes memory x;

  //   assembly {
  //     let junkSpace := 0x5C
  //     // let x := add(mload(input), junkSpace)

  //     let x := mload(0x40)
  //     mstore(x, sig) // Place signature at begining of empty storage
  //     mstore(add(x, 0x04), add(mload(input), junkSpace))

  //     if iszero(call(not(0), 0x102, 0, x, size, x, 0xffff)) {
  //       revert(0, 0)
  //     }
  //     o := mload(x)
  //   }
  //   // emit LogBytes(x);
  //   return true;
  // }

  function insertObj(string memory tableName, bytes memory index, bytes memory data) internal returns (bool o) {
    bytes memory input = abi.encodeWithSignature("insertObj(string,bytes,bytes)", tableName, index, data);

    assembly {
      let size := mload(input)
      let x := add(input, 0x20)

      if iszero(call(not(0), 0x102, 0, x, size, o, 0xffff)) {
        revert(0, 0)
      }
      o := mload(x)
    }
  }

  function deleteObj(string memory tableName, bytes memory data) internal returns (bool o) {
    bytes memory input = abi.encodeWithSignature("deleteObj(string,bytes)", tableName, data);

    assembly {
      let size := mload(input)
      let x := add(input, 0x20)

      if iszero(call(not(0), 0x102, 0, x, size, o, 0xffff)) {
        revert(0, 0)
      }
      o := mload(x)
    }
  }

  function select1(string memory tableName, string memory index, bytes memory prefix) internal returns (bytes memory o) {
    bytes memory input = abi.encodeWithSignature("select1(string,string,bytes)", tableName, index, prefix);

    // uint256 osize;

    assembly {
      let size := mload(input)
      let x := add(input, 0x20)

      if iszero(call(not(0), 0x102, 0, x, size, o, 0xffff)) {
        revert(0, 0)
      }

      let osize := mload(o)
      mstore(0x40, add(x, add(osize, 0x20)))
    }
    // emit Log(osize);
    // emit LogBytes(o);
  }

  function select(string memory tableName, string memory index, bytes memory prefix) internal returns (bytes32 o) {
    bytes memory input = abi.encodeWithSignature("select(string,string,bytes)", tableName, index, prefix);

    // uint256 osize;

    assembly {
      let size := mload(input)
      let x := add(input, 0x20)

      if iszero(call(not(0), 0x102, 0, x, size, o, 0x20)) {
        revert(0, 0)
      }
      o := mload(o)
      // mstore(0x40, add(x, 0x20))
    }
    // emit Log(uint256(o));
    // emit LogBytes32(o);
    // emit LogBytes1(o[0]);
  }

  function next(bytes32 iter) internal returns (bytes memory o) {
    bytes memory input = abi.encodeWithSignature("next(bytes32)", iter);

    assembly {
      let size := mload(input)
      let x := add(input, 0x20)

      if iszero(call(not(0), 0x102, 0, x, size, o, 0xffff)) {
        revert(0, 0)
      }

      let osize := mload(o)
      mstore(0x40, add(mload(0x40), add(osize, 0x20)))
    }
    // // emit Log(osize);
    // emit LogBytes(o);
  }
}