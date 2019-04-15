pragma solidity ^0.5.0;

import "./EbakusDB.sol";

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
		// bytes memory tablesAbi = new bytes(0);
		EbakusDB.createTable(TableName, "Name", tablesAbi);
		// emit LogBool(true);
	}

	function get() external returns (uint64, string memory, string memory) {
		User memory u;

		bytes memory prefix = new bytes(0);
		bytes memory out = EbakusDB.get(TableName, "Name", prefix);

		(u.Id, u.Name, u.Pass) = abi.decode(out, (uint64, string, string));
		emit LogUser(u.Id, u.Name, u.Pass);
		return (u.Id, u.Name, u.Pass);
	}

	function select() external {
		User memory u;
		bytes memory out;

		bytes memory prefix = new bytes(0);
		bytes32 iter = EbakusDB.select(TableName, "Name", prefix);

		out = EbakusDB.next(iter);
		(u.Id, u.Name, u.Pass) = abi.decode(out, (uint64, string, string));
		emit LogUser(u.Id, u.Name, u.Pass);

		out = EbakusDB.next(iter);
		(u.Id, u.Name, u.Pass) = abi.decode(out, (uint64, string, string));
		emit LogUser(u.Id, u.Name, u.Pass);

		// out = EbakusDB.prev(iter);
		// (u.Id, u.Name, u.Pass) = abi.decode(out, (uint64, string, string));
		// emit LogUser(u.Id, u.Name, u.Pass);
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

	function deleteObj() external {
		// delete user with Id=1
		bytes memory input = abi.encode(1);
		bool out = EbakusDB.deleteObj(TableName, input);
		emit LogBool(out);
	}
}
