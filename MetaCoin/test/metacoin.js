
//const { promisify, expectThrow } = require('./helper/utils'); 

const expectThrow = require('./utils').expectThrow
// const promisify = require('./utils').promisify

const MetaCoin = artifacts.require("MetaCoin"); // артифакт контракта MetaCoin.sol из папки build

let MC //Чтобы не повторять запись const metaCoinInstance = await MetaCoin.deployed(); в каждом тесте
        // переменная данных контракта, все тесты меют к ней доступ

contract('MetaCoin', (accounts) => {
const OWNER_SIGNATURE = { from: accounts[0] }

 beforeEach(async() => {
        MC = await MetaCoin.new(OWNER_SIGNATURE);
        await MC.mint(accounts[1], 10000, OWNER_SIGNATURE)  // выпустил токены 
        await MC.approve(accounts[2], 20, { from: accounts[1] });
})

 // Test Ownable contract



 describe('Ownership', () => {  // describe - задаёт, что именно мы описываем, используется для группировки «рабочих лошадок» – блоков it.
        
// В названии блока it человеческим языком описывается, что должна делать функция, далее следует тест, который проверяет это.

    it('should have a owner', async () => { // ключевое слово async перед функцией гарантирует, что эта функция в любом случае вернёт промис
      const owner = await MC.owner() // префиксный оператор await работает только внутри async–функций
      assert.strictEqual(owner, accounts[0])
    })

    it('should throw then not owner try to transfer ownership', async () => {
      await expectThrow(MC.transferOwnership(accounts[4], { from: accounts[1] }))  // expectThrow - должно не выполняться (из helper)
    })
    
    
    it('should transfer owner when it needed', async () => {
      await MC.transferOwnership(accounts[1], { from: accounts[0] } )
      assert.strictEqual(await MC.owner.call(), accounts[1])
    })

   }) 

  describe('Transfer', () => {

    const initialHolder = accounts[1];
    const to = accounts[2];
    const amount = 500;
            
    it('should handle zero-transfer normaly', async() => {
      assert(await MC.transfer.call(accounts[1], 0, { from: accounts[0] }), 'zero-transfer has failed');
            
  })

    it('should handle transfer normaly', async() => {
      
      const amount = 10;
      assert(await MC.transfer(to, amount, { from: initialHolder }));
            
  })

    it('when the sender does not have enough balance', async() => {
    return expectThrow(MC.transfer(accounts[1], 1000, { from: accounts[0] }))
})


    it('when the recipient is the zero address', async() => {
      const zero_address = '0x0000000000000000000000000000000000000000'; 
    return expectThrow(MC.transfer( zero_address, 1000, { from: accounts[1] }))
})
    it('should emit Transfer event', async () => {
     
       
    let result = await MC.transfer(to, amount, { from: initialHolder });

    assert.equal(result.logs.length, 1);
    assert.equal(result.logs[0].event, 'Transfer');
    assert.equal(result.logs[0].args.to, to);
    //console.log(result);
    assert.equal(result.logs[0].args.value.valueOf(), amount);
   

});   
})
            
  describe('balanceOf', function () {

    describe('when the requested account has no tokens', function () {
      it('returns zero', async function () {
        //(await this.token.balanceOf(anotherAccount)).should.be.bignumber.equal('0');
        assert.equal(await MC.balanceOf(accounts[0]), 0);
      });
    });

    describe('when the requested account has some tokens', function () {
      it('returns the total amount of tokens',  async() => {
       assert.equal(await MC.balanceOf(accounts[1]), 10000); 
      });
    });
}); 


  describe('TransferFrom', () => {

    const initialHolder = accounts[1];
    const to = accounts[2];
    const amount = 20;
    const spender = accounts[2];

    describe('when the initial holder has enough balance', function () {
            
    it('transfers the requested amount', async() => {
      assert (await MC.transferFrom(initialHolder, to, amount, { from: spender }));// (initialHolder, to, amount, { from: spender })
       
      assert.equal(await MC.balanceOf(initialHolder), 9980);

      assert.equal(await MC.balanceOf(to), amount);


  })
    
    it('should emit Transfer event', async () => {
     
       
    let result = await MC.transferFrom(initialHolder, to, amount, { from: spender });

    assert.equal(result.logs.length, 1);
    assert.equal(result.logs[0].event, 'Transfer');
    assert.equal(result.logs[0].args.from, initialHolder);
    assert.equal(result.logs[0].args.to, to);
    //console.log(result);
    assert.equal(result.logs[0].args.value.valueOf(), amount);
   

});   
});

})



});

























































     
 




            

    




/*
  it('should put 10000 MetaCoin in the first account', async () => {  // "название", async функция

    const balance = await MC.getBalance.call(accounts[0]); // await,контракт,название функции, call - вызов, вх. парам. функц. (address owner или accounts[0]) 

    assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");// assert, свойство assert (сравнение) balance.valueOf() / cо значением
  });                                                                           // Для численного преобразования объекта используется метод valueOf



  it('should transfer token correctly', async () => {
    
    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balances of first and second account.
    const accountOneStartingBalance = (await MC.BalanceOf.call(accountOne)).toNumber();
    const accountTwoStartingBalance = (await MC.BalanceOf.call(accountTwo)).toNumber();

    // Make transaction from first account to second.
    const amount = 10;
    await MC.transfer(accountTwo, amount, { from: accountOne });

    // Get balances of first and second account after the transactions.
    const accountOneEndingBalance = (await MC.BalanceOf.call(accountOne)).toNumber();
    const accountTwoEndingBalance = (await MC.BalanceOf.call(accountTwo)).toNumber();


    assert.equal(accountOneEndingBalance, accountOneStartingBalance - amount, "Amount wasn't correctly taken from the sender");
    assert.equal(accountTwoEndingBalance, accountTwoStartingBalance + amount, "Amount wasn't correctly sent to the receiver");
  });


  it('should emit Transfer event', async () => {
    
 
    const amount = 0;
    
    let result = await MC.transfer(accounts[1], amount, { from: accounts[0] });

    assert.equal(result.logs.length, 1);
    assert.equal(result.logs[0].event, 'Transfer');
    assert.equal(result.logs[0].args._to, accounts[1]);
    //console.log(result);
    //assert.equal(result.logs[0].args._value.valueOf(), amount);
   

});       
  

   


  

  

  it('approvals: msg.sender should approve 100 to accounts[1]', async () => {

    //const metaCoinInstance = await MetaCoin.deployed();

    await MC.approve(accounts[1], 100, { from: accounts[0] });
    const allowance = await MC.allowance.call(accounts[0], accounts[1]);
    assert.strictEqual(allowance.toNumber(), 100);
});


it('should emit Approval event', async () => {
    
    //const metaCoinInstance = await MetaCoin.deployed();
       
    
    let result = await MC.approve(accounts[1], 100, { from: accounts[0] });

    assert.equal(result.logs.length, 1);
    assert.equal(result.logs[0].event, 'Approval');
    assert.strictEqual(result.logs[0].args._spender, accounts[1]);// strictEqual и equal сввойства assert
    assert.equal(result.logs[0].args._owner, accounts[0])
    assert.equal(result.logs[0].args._value.valueOf(), 100);
   

}); 

  it('transfers: should handle zero-transfers normally', async () => {

    //const metaCoinInstance = await MetaCoin.deployed();

    assert(await MC.sendCoin.call(accounts[1], 0, { from: accounts[0] }), 'zero-transfer has failed');
});

*/



    
    




