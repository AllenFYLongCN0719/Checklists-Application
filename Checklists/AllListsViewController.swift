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

class AllListsViewController: UITableViewController,ListDetailViewControllerDelegate,UINavigationControllerDelegate {
//添加ListDetailViewControllerDelegate来使得它遵循这个一个协议，然后拓展prepare(for:sender:)
//然后在底部添加协议方法
    
    var dataModel: DataModel!
    //添加一个新的实例变量
    
//    var lists: [Checklist]
    
//    required init?(coder aDecoder: NSCoder) {
//        lists = [Checklist]()
//        //给lists变量一个值
//
//        super.init(coder: aDecoder)
//        //调用init?(coder)父类的初始化方法。
//
//        loadChecklist()
//        //调用加载方法。
//        //并在Checklist.swift中添加NSCoding协议。
//
//        var list = Checklist(name: "Birthdays")
//        //创建一个新的Checklist对象，给它一个名称。这里使用Checklist(name:)需要在Checklist.swift中添加自建方法init(name: String)
//        lists.append(list)
//        //将它添加到数组中。
//
//        list = Checklist(name: "Groceries")
//        lists.append(list)
//
//        list = Checklist(name: "Cool Apps")
//        lists.append(list)
//
//        list = Checklist(name: "To Do")
//        lists.append(list)
//
//        for list in lists {
//            //语句重复多次循环执行。
//            //这里的意思是对每一个在lists数组中的list(Checklist)对象执行以下操作
//            let item = ChecklistItem()
//            //创建新的ChecklistItem对象
//            item.text = "Item for \(list.name)"
//            //设置它的文本属性为"Item for Birthdays"
//            list.items.append(item)
//            //将新的ChecklistItem添加到items数组中
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
        //显示数组中的内容。
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        //将显示内容放入cell中
        cell.accessoryType = .detailDisclosureButton
        //设置cell的类型
        
        cell.detailTextLabel!.text = "\(checklist.countUnCheckedItems()) Remaining"
        //调用Checklist中的countUnCheckedItems()方法，并且将count放入一个新的字符串，这个字符串就位于次级标签的文本属性中。
        let count = checklist.countUnCheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "No Items"
            } else if count == 0 {
                cell.detailTextLabel!.text = "All Done"
            } else {
                cell.detailTextLabel!.text = "\(checklist.countUnCheckedItems()) Remaining"
            }
        
        cell.imageView!.image = UIImage(named: checklist.iconName)
        //将图标放入cell中
        
        
        return cell
    }
    
    //添加table view的数据来源允许用户删除某一条记录
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        dataModel.lists.remove(at: indexPath.row)
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
        let checklist = dataModel.lists[indexPath.row]
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
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
            //.subtitle会在主标题下添加一个略小一点的次级标题。
        }
    }
    
    //手动执行转场。调用performSegue(withIdentifier,sender)
    
    //修改方法。添加能够在运行中断后保存所处页面位置的功能。
    //增加识别用户是否点击了导航栏上的back按钮，添加控制器的委托。
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: "ChecklistIndex")
        //添加的是这一行
        //这样就将这一行的index存储到UserDefaults下的"ChecklistIndex"中了
        
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        //现在sender用来传递用户点击的那一行的Checklist对象。
        //然后在AllListsViewController.swift里添加方法override func prepare(for:sender:)
    }
    
    //添加 在app启动时检查那条待办事项被选中了，并且通过用代码转场过去。使用viewDidAppear()方法中实现这个操作
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        //读取视图控制器内建的导航控制器属性。
        
        //let index = UserDefaults.standard.integer(forKey: "ChecklistIndex")
        
        let index = dataModel.indexOfSelectedChecklist
        //使用计算属性来调用UserDefaults。
        
        //添加防御型代码防止Checklist.plist与UserDefaults不同步
        //判断index位于0和数据模型中的checklists数量之间的一个值，避免了向dataModel.lists[index]请求某个index对象时，这个对象不存在的情况。
        if index >= 0 && index < dataModel.lists.count {
            //检查UserDefaults是否需要执行转场。
            //如果"ChecklistIndex"的值为-1,那就是说在App中断前，用户时停留在主界面上的。
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
            //如果值不是-1的话，说明用户在app中断前是停留在某条待办事项上的，所以就需要转场到相应的地方。
        }
        
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
    
    //执行排序：1. 新增的时候，2. 重命名的时候
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        //新增时排序
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        //重命名时排序
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    //添加UINavigationControllerDelegate的委托方法
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        //back按钮被点击了吗？
        if viewController === self{
            //如果back按钮被点击了，新的视图控制器是AllListsViewController自己，这时的值“-1”意味着没有任何一个具体的待办条目被选中
            //UserDefaults.standard.set(-1, forKey: "ChecklistIndex")
            
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    //添加更新数据的func
    override func viewWillAppear(_ animated: Bool) {
        //这个方法与viewDidAppear()是不同的。
        //viewWillAppear是在viewDidAppear之前被调用。
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

}
