//
//  AllListsViewController.swift
//  Checklists
//
//  Created by 龙富宇 on 2017/11/26.
//  Copyright © 2017年 AllenLong. All rights reserved.
//

// From 第二十课内容
// 1. 添加一个新的界面展示分类
// 2. 创建一个新的界面，可以使用户添加或者编辑新的分类
// 3. 当你点击具体一个分类时，显示其中的待办事项
// 4. 对分类进行保存和读取

import UIKit

class AllListsViewController: UITableViewController {
    
    var lists: [Checklist]
    
    required init?(coder aDecoder: NSCoder) {
        lists = [Checklist]()
        //给lists变量一个值
        
        super.init(coder: aDecoder)
        //调用init?(coder)父类的初始化方法。
        
        var list = Checklist(name: "Birthdays")
        //创建一个新的Checklist对象，给它一个名称。这里使用Checklist(name:)需要在Checklist.swift中添加自建方法init(name: String)
        lists.append(list)
        //将它添加到数组中。
        
        list = Checklist(name: "Groceries")
        lists.append(list)
        
        list = Checklist(name: "Cool Apps")
        lists.append(list)
        
        list = Checklist(name: "To Do")
        lists.append(list)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
        //显示数组中的内容。
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        
        let checklist = lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        //将显示内容放入cell中
        cell.accessoryType = .detailDisclosureButton
        //设置cell的类型
        return cell
    }
    
    //用代码设计cell单元
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        // -> UITableViewCell : 这里调用的是UITableViewCell而不是UITableView
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
    }
    
    //手动执行转场。调用performSegue(withIdentifier,sender)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowChecklist", sender: nil)
    }


}
