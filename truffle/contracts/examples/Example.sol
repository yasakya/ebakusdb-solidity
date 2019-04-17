pragma solidity ^0.5.0;

import "../EbakusDB.sol";

contract Example {
	event LogUser(uint Id, string Name, string Pass, string Email);
	event LogBool(bool _value);

	string TableName = "Users";

	struct User {
    uint64 Id;
    string Name;
    string Pass;
    string Email;
  }

	constructor() public {
		// [{
		// 	"type": "table",
		// 	"name": "Users",
		// 	"inputs": [
		// 		{"name": "Id", "type": "uint64"},
		// 		{"name": "Name", "type": "string"},
		// 		{"name": "Pass", "type": "string"},
		// 		{"name": "Email", "type": "string"}
		// 	]
		// }]
		string memory tablesAbi = '[{"type":"table","name":"Users","inputs":[{"name":"Id","type":"uint64"},{"name":"Name","type":"string"},{"name":"Pass","type":"string"},{"name":"Email","type":"string"}]}]';
		EbakusDB.createTable(TableName, "Name,Email", tablesAbi);
	}

	function get() external {
		User memory u;

		bytes memory prefix = new bytes(0);
		bytes memory out = EbakusDB.get(TableName, "Email", prefix);

		(u.Id, u.Name, u.Pass, u.Email) = abi.decode(out, (uint64, string, string, string));
		emit LogUser(u.Id, u.Name, u.Pass, u.Email);
	}

	function select() external {
		User memory u;
		bool found;
		bytes memory out;

		bytes memory prefix = new bytes(0);
		bytes32 iter = EbakusDB.select(TableName, "Name", prefix);

		(out ,found) = EbakusDB.next(iter);
		if (found) {
			(u.Id, u.Name, u.Pass, u.Email) = abi.decode(out, (uint64, string, string, string));
			emit LogUser(u.Id, u.Name, u.Pass, u.Email);
		}

		(out ,found) = EbakusDB.next(iter);
		if (found) {
			(u.Id, u.Name, u.Pass, u.Email) = abi.decode(out, (uint64, string, string, string));
			emit LogUser(u.Id, u.Name, u.Pass, u.Email);
		}

		(out ,found) = EbakusDB.next(iter);
		require(!found);
		emit LogBool(!found);
	}

	function insertObjs() external {
		User memory u;
		bytes memory input;

		u = User(1, "Harry", "123", "harry@ebakus.com");
		input = abi.encode(u.Id, u.Name, u.Pass, u.Email);
		bool out = EbakusDB.insertObj(TableName, input);
		emit LogBool(out);

		u = User(2, "Chris", "456", "chris@ebakus.com");
		input = abi.encode(u.Id, u.Name, u.Pass, u.Email);
		out = EbakusDB.insertObj(TableName, input);
		emit LogBool(out);
	}

	function updateObjs() external {
		User memory u;
		bytes memory input;

		u = User(1, "Harry", "1234", "harry@ebakus.com");
		input = abi.encode(u.Id, u.Name, u.Pass, u.Email);
		bool out = EbakusDB.insertObj(TableName, input);
		emit LogBool(out);

		u = User(2, "Chris", "4567", "chris@ebakus.com");
		input = abi.encode(u.Id, u.Name, u.Pass, u.Email);
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
