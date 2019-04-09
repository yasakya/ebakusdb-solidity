const EbakusDB = artifacts.require('EbakusDB');
const Example = artifacts.require('Example');

module.exports = async function(deployer) {
  deployer.deploy(EbakusDB);
  deployer.link(EbakusDB, Example);
  await deployer.deploy(Example);

  console.log('Example address: ', Example.address);
  console.warn('----------------');

  const instance = await Example.deployed();

  // try {
  //   const getResult = await instance.get.call(web3.utils.toWei('1', 'ether'));
  //   console.log('Get: ', web3.utils.fromWei(getResult, 'ether'));

  //   // const receipt = await instance.get(web3.utils.toWei('1', 'ether'));
  //   // console.log('Logs 1: ', receipt.logs[0].args._value.toString(10));
  //   // console.log('Logs 2: ', receipt.logs[1].args._value.toString(10));
  // } catch (err) {
  //   console.log('Err: ', err);
  // }

  // try {
  //   const setResult = await instance.set.call(web3.utils.toWei('1', 'ether'));
  //   console.log('Set: ', web3.utils.fromWei(setResult, 'ether'));

  //   // const receipt = await instance.set(web3.utils.toWei('1', 'ether'));
  //   // console.log('Logs 1: ', receipt.logs[0].args._value.toString(10));
  //   // console.log('Logs 2: ', receipt.logs[1].args._value.toString(10));
  // } catch (err) {
  //   console.log('Err: ', err);
  // }

  // try {
  //   // const forStructResult = await instance.forStruct.call();
  //   // console.log('ForStruct: ', forStructResult);

  //   const receipt = await instance.forStruct();
  //   console.log('Logs 1: ', receipt.logs);
  //   console.log('Logs 1: ', receipt.logs[2].args._value.toString(10));

  //   console.log('Log id: ', receipt.logs[3].args._value.toString(10));
  //   console.log('Log pass: ', receipt.logs[4].args._value.toString(10));
  //   console.log('Log user.id: ', receipt.logs[5].args.id.toString(10));
  //   console.log('Log user.pass: ', receipt.logs[5].args.pass.toString(10));
  // } catch (err) {
  //   console.log('Err: ', err);
  // }

  try {
    // const createTableResult = await instance.createTable.call();
    // console.log('CreateTable: ', createTableResult);

    const receipt = await instance.createTable();
    console.log('Logs: ', receipt.logs);
    console.warn('Table created: ', receipt.logs[0].args._value.toString(10));
  } catch (err) {
    console.log('Err: ', err);
  }

  try {
    // const createTableResult = await instance.createTable.call();
    // console.log('CreateTable: ', createTableResult);

    const receipt = await instance.insertObj();
    console.log('Logs: ', receipt.logs);
    console.warn(
      'Obj inserted: ',
      receipt.logs[receipt.logs.length - 1].args._value.toString(10)
    );
  } catch (err) {
    console.log('Err: ', err);
  }

  try {
    const receipt = await instance.select();
    console.log('Logs: ', receipt.logs);
    console.warn('Select Id: ', receipt.logs[0].args._value.toString(10));
    console.warn('Select Pass: ', receipt.logs[1].args._value.toString(10));
    console.log(
      'Select: User(%d, %d)',
      receipt.logs[receipt.logs.length - 2].args.id.toString(10),
      receipt.logs[receipt.logs.length - 2].args.pass.toString(10)
    );
    console.log(
      'Select: User2(%d, %d)',
      receipt.logs[receipt.logs.length - 1].args.id.toString(10),
      receipt.logs[receipt.logs.length - 1].args.pass.toString(10)
    );
  } catch (err) {
    console.log('Err: ', err);
  }

  // try {
  //   // const createTableResult = await instance.createTable.call();
  //   // console.log('CreateTable: ', createTableResult);

  //   const receipt = await instance.deleteObj();
  //   console.log('Logs: ', receipt.logs);
  //   console.warn(
  //     'Obj deleted: ',
  //     receipt.logs[receipt.logs.length - 1].args._value.toString(10)
  //   );
  // } catch (err) {
  //   console.log('Err: ', err);
  // }

  // try {
  //   const receipt = await instance.select();
  //   console.log('Logs: ', receipt.logs);
  //   console.warn('Select Id: ', receipt.logs[0].args._value.toString(10));
  //   console.warn('Select Pass: ', receipt.logs[1].args._value.toString(10));
  //   console.log(
  //     'Select: User(%d, %d)',
  //     receipt.logs[receipt.logs.length - 1].args.id.toString(10),
  //     receipt.logs[receipt.logs.length - 1].args.pass.toString(10)
  //   );
  // } catch (err) {
  //   console.log('Err: ', err);
  // }
};
