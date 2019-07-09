const EbakusDB = artifacts.require('EbakusDB');
const Example = artifacts.require('examples/Example');

module.exports = async function(deployer, network) {
  let ebakusdbDeployOptions = {};
  if (network !== 'development') {
    ebakusdbDeployOptions.overwrite = true;
  }

  await deployer.deploy(EbakusDB, ebakusdbDeployOptions);

  // Example use for development
  if (network === 'development') {
    await deployer.link(EbakusDB, Example);
    await deployer.deploy(Example);

    console.log('Example address: ', Example.address);
    console.warn('----------------');

    const instance = await Example.deployed();

    try {
      const receipt = await instance.insertObjs();
      console.warn(
        'User1 inserted: ',
        receipt.logs[0].args._value.toString(10)
      );
      console.warn(
        'User2 inserted: ',
        receipt.logs[1].args._value.toString(10)
      );
    } catch (err) {
      console.error('Users insertion err: ', err);
    }

    try {
      const receipt = await instance.select();
      console.log(
        'Select next: User1(%d, %s, %s, %s)',
        receipt.logs[0].args.Id.toString(10),
        receipt.logs[0].args.Name.toString(10),
        receipt.logs[0].args.Pass.toString(10),
        receipt.logs[0].args.Email.toString(10)
      );
      console.log(
        'Select next: User2(%d, %s, %s, %s)',
        receipt.logs[1].args.Id.toString(10),
        receipt.logs[1].args.Name.toString(10),
        receipt.logs[1].args.Pass.toString(10),
        receipt.logs[1].args.Email.toString(10)
      );

      console.log(
        'Select next: No other users found: ',
        receipt.logs[2].args._value.toString(10)
      );
    } catch (err) {
      console.error('Select Users err: ', err);
    }

    try {
      const receipt = await instance.updateObjs();
      console.warn(
        'User1 inserted: ',
        receipt.logs[0].args._value.toString(10)
      );
      console.warn(
        'User2 inserted: ',
        receipt.logs[1].args._value.toString(10)
      );
    } catch (err) {
      console.error('Users insertion err: ', err);
    }

    try {
      const receipt = await instance.get();
      console.log(
        'Get user: %d, %s, %s, %s',
        receipt.logs[0].args.Id.toString(10),
        receipt.logs[0].args.Name.toString(10),
        receipt.logs[0].args.Pass.toString(10),
        receipt.logs[0].args.Email.toString(10)
      );
    } catch (err) {
      console.error('Get User2 err: ', err);
    }

    try {
      const receipt = await instance.deleteObj();
      console.warn('User2 deleted: ', receipt.logs[0].args._value.toString(10));
    } catch (err) {
      console.error('User2 deletion err: ', err);
    }

    try {
      const receipt = await instance.get();
      console.log(
        'Get user: %d, %s, %s',
        receipt.logs[0].args.Id.toString(10),
        receipt.logs[0].args.Name.toString(10),
        receipt.logs[0].args.Pass.toString(10),
        receipt.logs[0].args.Email.toString(10)
      );
    } catch (err) {
      console.error('Get User1 err: ', err);
    }
  }
};
