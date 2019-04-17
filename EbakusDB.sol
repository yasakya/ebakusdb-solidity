pragma solidity ^0.5.0;

/**
 * @title EbakusDB
 * @author Ebakus
 * @notice Library for giving access to EbakusDB
 */
library EbakusDB {

  /**
   * @notice Create a table at EbakusDB
   * @dev This has to be called once per table. Usually it makes sense to occur in contract's constructor,
   *      as it will run once and will be removed from the deployed code.
   * @param tableName Table name
   * @param indexes List of indexed fields (comma separated)
   * @param tablesAbi ABI represantation of the solidity struct defining the table
   *
   *   Example solidity struct:
   *
   *     struct User {
   *       uint64 Id;
   *       string Name;
   *     }
   *
   *   Example table ABI:
   *
   *     [{
   *       "type": "table",
   *       "name": "Users",
   *       "inputs": [
   *         {"name": "Id", "type": "uint64"},
   *         {"name": "Name", "type": "string"},
   *       ]
   *     }]
   *
   * @return true if Bugs will eat it, false otherwise
   */
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

  /**
   * @notice Get a single entry from EbakusDB
   * @dev Transaction will fail if nothing is mathed in EbakusDB
   * @param tableName Table name
   * @param index Index to be used for ordering and matching using the prefix
   * @param key Value to be used for matching an entry
   * @return ABI encoded object, read using abi.decode(...)
   */
  function get(string memory tableName, string memory index, bytes memory key) internal returns (bytes memory o) {
    bytes memory input = abi.encodeWithSignature("get(string,string,bytes)", tableName, index, key);
    return getBytes(input);
  }

  /**
   * @notice Select entries from EbakusDB
   * @param tableName Table name
   * @param index Index to be used for ordering and matching using the prefix
   * @param prefix Value to be used for matching an entry
   * @return Select iterator that has to be passed in EbakusDB.next(...)
   */
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

  /**
   * @notice Insert/Update an entry in EbakusDB
   * @param tableName Table name
   * @param data ABI encoded object, encode using abi.encode(...)
   * @return true if entry has been inserted/updated
   */
  function insertObj(string memory tableName, bytes memory data) internal returns (bool o) {
    bytes memory input = abi.encodeWithSignature("insertObj(string,bytes)", tableName, data);
    return getBool(input);
  }

  /**
   * @notice Delete an entry in EbakusDB
   * @param tableName Table name
   * @param data ABI encoded object's "Id" value, encode using abi.encode(...)
   * @return true if entry has been deleted
   */
  function deleteObj(string memory tableName, bytes memory data) internal returns (bool o) {
    bytes memory input = abi.encodeWithSignature("deleteObj(string,bytes)", tableName, data);
    return getBool(input);
  }

  /**
   * @notice Get next entry for a select query made at EbakusDB
   * @param iter Select's iterator retrieved by EbakusDB.select(...)
   * @return ABI encoded object, read using abi.decode(...)
   */
  function next(bytes32 iter) internal returns (bytes memory o, bool found) {
    bytes memory input = abi.encodeWithSignature("next(bytes32)", iter);
    o = getBytes(input);
    return (o, o.length > 0);
  }

  /**
   * @notice Get previous entry for a select query made at EbakusDB
   * @param iter Select's iterator retrieved by EbakusDB.select(...)
   * @return ABI encoded object, read using abi.decode(...)
   */
  function prev(bytes32 iter) internal returns (bytes memory o, bool found) {
    bytes memory input = abi.encodeWithSignature("prev(bytes32)", iter);
    o = getBytes(input);
    return (o, o.length > 0);
  }

  /**
   * @notice Call EbakusDB system contract and fetch back some bytes
   * @param input ABI encoded EbakusDB system contract command
   * @return ABI encoded object, read using abi.decode(...)
   */
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

  /**
   * @notice Call EbakusDB system contract and fetch back a boolean value
   * @param input ABI encoded EbakusDB system contract command
   * @return boolean
   */
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