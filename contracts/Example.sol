pragma solidity ^0.5.0;

import "./EbakusDB.sol";

contract Example {
	event LogUser(uint Id, string Name, string Pass);
	event LogBool(bool _value);

	string TableName = "Users";

	struct User {
    uint256 Id;
    string Name;
    string Pass;
  }

	constructor() public {
	}

	function createTable() external {
		bool out = EbakusDB.createTable(TableName, "Name");
		emit LogBool(out);
	}

	function select1() external returns (uint256, string memory, string memory) {
		User memory u;

		bytes memory prefix = new bytes(0);
		bytes memory out = EbakusDB.select1(TableName, "Name", prefix);

		(u.Id, u.Name, u.Pass) = abi.decode(out, (uint256, string, string));
		emit LogUser(u.Id, u.Name, u.Pass);
		return (u.Id, u.Name, u.Pass);
	}

	function select() external {
		User memory u;
		bytes memory out;

		bytes memory prefix = new bytes(0);
		bytes32 iter = EbakusDB.select(TableName, "Name", prefix);

		out = EbakusDB.next(iter);
		(u.Id, u.Name, u.Pass) = abi.decode(out, (uint256, string, string));
		emit LogUser(u.Id, u.Name, u.Pass);

		out = EbakusDB.next(iter);
		(u.Id, u.Name, u.Pass) = abi.decode(out, (uint256, string, string));
		emit LogUser(u.Id, u.Name, u.Pass);

		// out = EbakusDB.prev(iter);
		// (u.Id, u.Name, u.Pass) = abi.decode(out, (uint256, string, string));
		// emit LogUser(u.Id, u.Name, u.Pass);
	}

	function insertObj() external {
		User memory u;
		bytes memory index;
		bytes memory input;

		u = User(1, "Harry", "123");
		index = abi.encode(u.Id);
		input = abi.encode(u.Id, u.Name, u.Pass);
		bool out = EbakusDB.insertObj(TableName, index, input);
		emit LogBool(out);

		u = User(2, "Chris", "456");
		index = abi.encode(u.Id);
		input = abi.encode(u.Id, u.Name, u.Pass);
		out = EbakusDB.insertObj(TableName, index, input);
		emit LogBool(out);
	}

	function deleteObj() external {
		// delete user with Id=1
		bytes memory input = abi.encode(1);
		bool out = EbakusDB.deleteObj(TableName, input);
		emit LogBool(out);
	}
}
