const EbakusDB = artifacts.require('EbakusDB');
const Example = artifacts.require('Example');

module.exports = async function(deployer) {
  deployer.deploy(EbakusDB);
  deployer.link(EbakusDB, Example);
  await deployer.deploy(Example);

  console.log('Example address: ', Example.address);
  console.warn('----------------');

  const instance = await Example.deployed();

  try {
    const receipt = await instance.createTable();
    console.warn('Table created.');
  } catch (err) {
    console.error('Table exists or something went wrong.');
  }

  try {
    const receipt = await instance.insertObj();
    console.warn('User1 inserted: ', receipt.logs[0].args._value.toString(10));
    console.warn('User2 inserted: ', receipt.logs[1].args._value.toString(10));
  } catch (err) {
    console.error('Users insertion err: ', err);
  }

  try {
    const receipt = await instance.select();
    console.log(
      'Select next: User1(%d, %s, %s)',
      receipt.logs[0].args.Id.toString(10),
      receipt.logs[0].args.Name.toString(10),
      receipt.logs[0].args.Pass.toString(10)
    );
    console.log(
      'Select next: User2(%d, %s, %s)',
      receipt.logs[1].args.Id.toString(10),
      receipt.logs[1].args.Name.toString(10),
      receipt.logs[1].args.Pass.toString(10)
    );
  } catch (err) {
    console.error('Select Users err: ', err);
  }

  try {
    const res = await instance.get.call();
    console.log(
      'Get User1 = Id:',
      res[0].toString(10),
      'Name:',
      res[1],
      'Pass:',
      res[2],
      'Email:',
      res[3]
    );
  } catch (err) {
    console.error('Get User1 err: ', err);
  }

  try {
    const receipt = await instance.deleteObj();
    console.warn('User1 deleted: ', receipt.logs[0].args._value.toString(10));
  } catch (err) {
    console.error('User1 deletion err: ', err);
  }

  try {
    const res = await instance.get.call();
    console.log(
      'Get User1 = Id:',
      res[0].toString(10),
      'Name:',
      res[1],
      'Pass:',
      res[2]
    );
  } catch (err) {
    console.error('Get User1 err: ', err);
  }
};
