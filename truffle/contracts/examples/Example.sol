pragma solidity ^0.5.0;

import "../EbakusDB.sol";

contract Example {
	event LogUser(uint Id, string Name, string Pass);
	event LogBool(bool _value);

	string TableName = "Users";

	struct User {
    uint64 Id;
    string Name;
    string Pass;
  }

	constructor() public {
	}

	// This is the constructor which creates the db tables and registers the ABI for them.
	// constructor() public {
	// 	// [{
	// 	// 	"type": "table",
	// 	// 	"name": "Users",
	// 	// 	"inputs": [
	// 	// 		{"name": "Id", "type": "uint64"},
	// 	// 		{"name": "Name", "type": "string"},
	// 	// 		{"name": "Pass", "type": "string"},
	// 	// 		{"name": "Email", "type": "string"}
	// 	// 	]
	// 	// }]
	// 	string memory tablesAbi = '[{"type":"table","name":"Users","inputs":[{"name":"Id","type":"uint64"},{"name":"Name","type":"string"},{"name":"Pass","type":"string"}]}]';

	// 	bool created = EbakusDB.createTable(TableName, "Name", tablesAbi);
	// 	require(created);
	// }

	function createTable() external {
		// [{
		// 	"type": "table",
		// 	"name": "Users",
		// 	"inputs": [
		// 		{"name": "Id", "type": "uint64"},
		// 		{"name": "Name", "type": "string"},
		// 		{"name": "Pass", "type": "string"}
		// 	]
		// }]
		string memory tablesAbi = '[{"type":"table","name":"Users","inputs":[{"name":"Id","type":"uint64"},{"name":"Name","type":"string"},{"name":"Pass","type":"string"}]}]';
		EbakusDB.createTable(TableName, "Name", tablesAbi);
	}

	function get() external {
		User memory u;

		bytes memory prefix = new bytes(0);
		bytes memory out = EbakusDB.get(TableName, "Name", prefix);

		(u.Id, u.Name, u.Pass) = abi.decode(out, (uint64, string, string));
		emit LogUser(u.Id, u.Name, u.Pass);
	}

	function select() external {
		User memory u;
		bool found;
		bytes memory out;

		bytes memory prefix = new bytes(0);
		bytes32 iter = EbakusDB.select(TableName, "Name", prefix);

		(out ,found) = EbakusDB.next(iter);
		if (found) {
			(u.Id, u.Name, u.Pass) = abi.decode(out, (uint64, string, string));
			emit LogUser(u.Id, u.Name, u.Pass);
		}

		(out ,found) = EbakusDB.next(iter);
		if (found) {
			(u.Id, u.Name, u.Pass) = abi.decode(out, (uint64, string, string));
			emit LogUser(u.Id, u.Name, u.Pass);
		}

		(out ,found) = EbakusDB.next(iter);
		emit LogBool(!found);
		if (found) {
			(u.Id, u.Name, u.Pass) = abi.decode(out, (uint64, string, string));
			emit LogUser(u.Id, u.Name, u.Pass);
		}
	}

	function insertObj() external {
		User memory u;
		bytes memory input;

		u = User(1, "Harry", "123");
		input = abi.encode(u.Id, u.Name, u.Pass);
		bool out = EbakusDB.insertObj(TableName, input);
		emit LogBool(out);

		u = User(2, "Chris", "456");
		input = abi.encode(u.Id, u.Name, u.Pass);
		out = EbakusDB.insertObj(TableName, input);
		emit LogBool(out);
	}

	function insertObj2() external {
		User memory u;
		bytes memory input;

		u = User(1, "Harry", "1234");
		input = abi.encode(u.Id, u.Name, u.Pass);
		bool out = EbakusDB.insertObj(TableName, input);
		emit LogBool(out);

		u = User(2, "Chris", "4567");
		input = abi.encode(u.Id, u.Name, u.Pass);
		out = EbakusDB.insertObj(TableName, input);
		emit LogBool(out);
	}

	function deleteObj() external {
		// delete user with Id=1
		bytes memory input = abi.encode(2);
		bool out = EbakusDB.deleteObj(TableName, input);
		emit LogBool(out);
	}
}
