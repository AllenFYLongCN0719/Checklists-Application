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

class AllListsViewController: UITableViewController,ListDetailViewControllerDelegate {
//添加ListDetailViewControllerDelegate来使得它遵循这个一个协议，然后拓展prepare(for:sender:)
//然后在底部添加协议方法
    
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
    
    //添加table view的数据来源允许用户删除某一条记录
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    //修改已存在条目的方法。手动从故事模版中读取这个新的视图控制器。（扩展视图响应）
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //为Add/Edit Checklist界面创建了新的视图控制器对象，并且展现在屏幕上。
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavgationController") as! UINavigationController
        //这个视图控制器被嵌入在故事模版中，并请求故事模版读取它。确定storyboard不会为nil，所以使用感叹号强制解包。
        //在指向List Detail View Controller的导航器视图的身份检查器中，将ListDetailNavgationController添加在Storybord ID里。
        //原因是ListDetailViewController是嵌入在导航控制器内部中的，如果将Storyboard ID填在ListDetailViewController里，导航控制器将无法被看到也就是被为空。
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        let checklist = lists[indexPath.row]
        controller.checklistToEdit = checklist
        present(navigationController, animated: true, completion: nil)
    }
    
    //手动创建 - 用代码设计cell单元
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        // -> UITableViewCell : 这里调用的是UITableViewCell而不是UITableView
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            //使用dequeueReuasableCell()进行重用cell
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
    }
    
    //手动执行转场。调用performSegue(withIdentifier,sender)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        //现在sender用来传递用户点击的那一行的Checklist对象。
        //然后在AllListsViewController.swift里添加方法override func prepare(for:sender:)
    }
    
    //将sender的参数checklist给到ChecklistViewController。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as! Checklist
            //controller.checklist被sender的Checklist对象填充，并且viewDidLoad()可以据此修改界面的标题。
        } else if segue.identifier == "AddChecklist" {
            //寻找导航控制器中的视图控制器，并且设置它的delegate为self
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }

    //以下方法会在用户点击Cancel或Done按钮时被调用
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }

    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        let newRowIndex = lists.count
        lists.append(checklist)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = lists.index(of: checklist) {
            let indexPath = IndexPath(row:index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = checklist.name
            }
        }
        dismiss(animated: true, completion: nil)
    }

}
