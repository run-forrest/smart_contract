# 接收ETH

## 接收ETH的相关关键字 : payable, fallback, receive

### payable

用来标记函数和地址使用

标记function时，表示可以接收以太的操作

标记address时，表示该地址可以接收以太

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Payable {

    // payable 标记函数
    // 加上 payable后，可以接收以太币
    function deposit1() external payable {}

    function deposit2() external {}

    // payable 标记地址
    // 将合约内所有余额转到当前账户，to.transfer(from)
    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }

    // 通过balance属性，来查看余额
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
```

### fallback

语法1：`fallback() external [payable]`

语法2：`fallback(bytes calldata input) external [payable] returns (bytes memory output)`

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Payable {
    event Log(string funName, address from, uint256 value, bytes data);

    function deposit() external payable{}

    //通过balance属性，查看余额
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract StoneCat {
    uint256 public age = 0;
    event eventFallback(string);

    // 发送这个合约的所有消息都会调用此函数（因为该合约没有其他函数）
    // 向这个合约发送以太币会导致异常， 因为fallback函数没有’payable‘ 修饰符
    // fallback是一个兜底函数，最终最终一定会走到这里
    fallback() external {
        age++;
        emit eventFallback("fallback");
    }

    // 获取合约的名字，‘Hello’
    function name() public pure returns(string memory){
        return type(StoneCat).name;
    }
}

interface AnimalEat {
    function eat() external returns (string memory);
}

contract Animal {
    // 传入stonecat address
    // 会报错，无法调用
    function test1(address _addr) external returns (string memory) {
        AnimalEat general = AnimalEat(_addr);
        return general.eat();
    }
    // call方法，比较底层，会绕过合约的检测，所有官方不推荐这样调用
    // 传入tonecat address可以调用，其实调用的是fallback方法,age会++
    // 但是如果里面有eth数量，就会失败，因为fallback没有’payable‘修饰符
    function test2(address _addr) external returns (bool success) {
        AnimalEat general = AnimalEat(_addr);
        (success,) = address(general).call(abi.encodeWithSignature("eat()"));
        require(success);
    }
}

contract Demo {
    bytes public inputData1;
    bytes public inputData2;

    fallback (bytes calldata input) external returns (bytes memory output) {
        inputData1 = input;
        inputData2 = msg.data; // input 等于msg.data
        return input;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract StoneCat {
    uint256 public age = 0;
    bytes public inputData1;
    bytes public inputData2;
    uint256 public c;
    uint256 public d;

    event eventFallback(string);

    fallback(bytes calldata input) external returns (bytes memory output){
        age++;
        inputData1 = input;
        inputData2 = msg.data;
        // data值需要从第四位开始裁剪
        // decode解码，将(uint256, uint256) 返回给(c, d) 
        // abi可以对调用的数据进行解码
        (c, d) = abi.decode(msg.data[4:], (uint256, uint256));
        emit eventFallback("fallback");
        return input;
    }

}

interface AnimalEat {
    function eat() external returns (string memory);
}

contract Animal {
    // call方法，比较底层，会绕过合约的检测，所有官方不推荐这样调用
    // 传入tonecat address可以调用，其实调用的是fallback方法,age会++
    // 但是如果里面有eth数量，就会失败，因为fallback没有’payable‘修饰符
    function test2(address _addr) external returns (bool success) {
        AnimalEat general = AnimalEat(_addr);
        (success,) = address(general).call(abi.encodeWithSignature("eat()",123,456));
        require(success);
    }
}
```

函数被调用的两种情况：

向合约转账，执行合约不存在的方法

receive： 只负责接收主币

- `receive() external payable {}`
- payable必须要存在
- 没有function关键字

receive和fallback共存调用

```solidity
contract Demo {
    event Log(string funName, address from, uint256 value, bytes data);

    // receive只接收主币
    receive() external payable{
        // receive 被调用的时候不存在msg.data,所以不适用这个，直接用空字符串
        emit Log("receive", msg.sender, msg.value, "");
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
// Log 输出内容 ：
			"funName": "receive",
			"from": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
			"value": "0",
			"data": "0x"
```

推荐写法：fallback只拿来做回调函数，receive用来接收地址

同时存在receive和fallback时的优先级顺序：

如果msg.sender为空，并且存在receive的时候，才会运行receive，不然就一直运行fallback
