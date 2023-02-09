// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// 1. 创建任务
//   8点到公园玩： false
// 2. 修改任务名称
//    任务名写错时
// 3 修改完成状态： 8点到公园玩：true
//    手动指定完成或者未完成
//   自动切换toggle
//      如果未完成 ,改为完成
//      如果完成，改为未完成
//  4.获取任务
//      任务ID
contract TodoList {
    struct Todo{
        string name;
        bool isCompleted;
    }
    Todo[] public list;

    // 创建任务
    function create(string memory name_) external {
        list.push(Todo({name: name_, isCompleted: false}));
    }

    // 修改任务名称
    // 方法1：比较省gas费
    function modiName(uint256 index_, string memory name_) external {
        list[index_].name = name_;
    }

    // 方法2： 先获取储存在storage，再修改
    function modiName2(uint256 index_, string memory name_) external {
        Todo storage temp = list[index_];
        temp.name = name_;
    }

    // 修改完成状态1： 手动指定完成或者未完成
    function modiStatus(uint256 index_, bool status_) external {
        list[index_].isCompleted = status_;
    }

    // 修改完成状态1： 自动切换任务
    function modiStatus2(uint256 index_) external {
        list[index_].isCompleted = !list[index_].isCompleted;
    }

    // 添加tode
    function addTodo(string memory name_, bool status_) external {
        list.push(Todo({name: name_, isCompleted: status_}));
    }
}
