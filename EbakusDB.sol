pragma solidity ^0.5.0;

/**
 * @title EbakusDB
 * @dev Library for giving access to EbakusDB.
 */
library EbakusDB {
  function createTable(string memory tableName, string memory indexes, string memory tablesAbi) internal {
    bytes memory input = abi.encodeWithSignature("createTable(string,string,string)", tableName, indexes, tablesAbi);

    assembly {
      let size := mload(input)
      let x := add(input, 0x20)

      if iszero(call(not(0), 0x102, 0, x, size, x, 0x00)) {
        revert(0, 0)
      }
    }
  }

  function get(string memory tableName, string memory index, bytes memory prefix) internal returns (bytes memory o) {
    bytes memory input = abi.encodeWithSignature("get(string,string,bytes)", tableName, index, prefix);
    return getBytes(input);
  }

  function select(string memory tableName, string memory index, bytes memory prefix) internal returns (bytes32 o) {
    bytes memory input = abi.encodeWithSignature("select(string,string,bytes)", tableName, index, prefix);

    assembly {
      let size := mload(input)
      let x := add(input, 0x20)

      if iszero(call(not(0), 0x102, 0, x, size, o, 0x20)) {
        revert(0, 0)
      }
      o := mload(o)
    }
  }

  function insertObj(string memory tableName, bytes memory data) internal returns (bool o) {
    bytes memory input = abi.encodeWithSignature("insertObj(string,bytes)", tableName, data);
    return getBool(input);
  }

  function deleteObj(string memory tableName, bytes memory data) internal returns (bool o) {
    bytes memory input = abi.encodeWithSignature("deleteObj(string,bytes)", tableName, data);
    return getBool(input);
  }

  function next(bytes32 iter) internal returns (bytes memory o, bool found) {
    bytes memory input = abi.encodeWithSignature("next(bytes32)", iter);
    o = getBytes(input);
    // if (o.length != 0) {
    //   return (o, true);
    // } else {
    //   return (o, false);
    // }

    return (o, o.length > 0);
  }

  function prev(bytes32 iter) internal returns (bytes memory o, bool found) {
    bytes memory input = abi.encodeWithSignature("prev(bytes32)", iter);
    o = getBytes(input);
    return (o, o.length > 0);
  }

  function getBytes(bytes memory input) private returns (bytes memory o) {
    assembly {
      let size := mload(input)
      let x := add(input, 0x20)

      if iszero(call(not(0), 0x102, 0, x, size, o, 0xffff)) {
        revert(0, 0)
      }

      let osize := mload(o)
      mstore(0x40, add(mload(0x40), add(osize, 0x20)))
    }
  }

  function getBool(bytes memory input) private returns (bool o) {
    assembly {
      let size := mload(input)
      let x := add(input, 0x20)

      if iszero(call(not(0), 0x102, 0, x, size, o, 0x20)) {
        revert(0, 0)
      }
      o := mload(o)
    }
  }
}