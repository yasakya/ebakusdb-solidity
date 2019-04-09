pragma solidity ^0.5.7;
// pragma experimental ABIEncoderV2;

import "./EbakusDB.sol";

contract Example {
	event Log(uint _value);
	event LogUser(uint id, uint pass);
	event LogBytes(bytes _value);
	event LogBytes32(bytes32[] _value);
	event LogBool(bool _value);

	string TableName = "TestExample";

	struct User {
    uint256 Id;
    uint256 Pass;
  }
	User[] users;

	constructor() public {
		// balances[tx.origin] = 10000;
	}

	function get(uint256 amount) external returns(uint256) {
		return EbakusDB.get(amount);
	}

	function set(uint256 amount) external returns(uint256) {
		return EbakusDB.set(amount);
	}

	function forStruct() external {
		// bytes[] memory ar;
		bytes memory out = EbakusDB.forStruct();

		// (ar) = abi.decode(out, (bytes[]));
		// // for (uint i = 0; i < 1; i++) {
			// (uint _id, uint _pass) = abi.decode(ar[i], (uint, uint));
			// User memory u = User(_id, _pass);
			// emit LogUser(u.Id, u.Pass);
		// }

		// bytes memory o = new bytes(0x40);
		// o[0] = "a";
		// o[0x40-1] = "b";

		// emit LogBytes(o);
		emit LogBytes(out);

		// uint256 _id;
		// uint256 _pass;

		// (_id, _pass) = abi.decode(out, (uint256, uint256));
		// emit Log(_id);
		// emit Log(_pass);
		// User memory u = User(_id, _pass);
		// emit LogUser(u.Id, u.Pass);
	}

// 	function decoce(data) private {
//     uint _amount;
//     address _receiver;
//     address _tokenLeadContract;
//     uint _expectedAmount;
//     address _expectedSC;
//     (_amount, _receiver, _tokenLeadContract, _expectedAmount, _expectedSC) = abi.decode(data, (uint, address, address, uint, address));
//  }

		function createTable() external {
			// string[] memory indexes;
			// indexes[0] = "Name";
			// indexes[1] = "Number";
			// bool out = EbakusDB.createTable(TableName, indexes);

			bool out = EbakusDB.createTable(TableName, "Id");
			emit LogBool(out);
			// return out;
		}

		function insertObj() external {
			User memory u1 = User(1, 3);
			User memory u2 = User(2, 4);
			// users.push(u1);
			// users.push(u2);

			bytes memory index = abi.encode(u1.Id);
			bytes memory input = abi.encode(u1.Id, u1.Pass);
			emit LogBytes(index);
			emit LogBytes(input);

			bool out = EbakusDB.insertObj(TableName, index, input);
			emit LogBool(out);
			// return out;

			index = abi.encode(u2.Id);
			input = abi.encode(u2.Id, u2.Pass);
			out = EbakusDB.insertObj(TableName, index, input);
		}

		function deleteObj() external {
			User memory u1 = User(1, 3);
			// User memory u2 = User(2, 4);
			// users.push(u1);
			// users.push(u2);

			bytes memory input = abi.encode(u1.Id);
			emit LogBytes(input);

			bool out = EbakusDB.deleteObj(TableName, input);
			emit LogBool(out);

			User memory u2 = User(2, 4);
			input = abi.encode(u2.Id);
			emit LogBytes(input);

			out = EbakusDB.deleteObj(TableName, input);
			emit LogBool(out);
			// return out;
		}

		function select() external {
			bytes memory prefix = new bytes(0);
			bytes32 iter = EbakusDB.select(TableName, "Id", prefix);
			// emit LogBytes(iter);
			bytes memory out = EbakusDB.next(iter);
			emit LogBytes(out);

			uint256 _id;
			uint256 _pass;

			(_id, _pass) = abi.decode(out, (uint256, uint256));
			emit Log(_id);
			emit Log(_pass);

			User memory u = User(_id, _pass);
			emit LogUser(u.Id, u.Pass);

			out = EbakusDB.next(iter);

			User memory u2;
			(u2.Id, u2.Pass) = abi.decode(out, (uint256, uint256));
			emit LogUser(u2.Id, u2.Pass);
		}
}
