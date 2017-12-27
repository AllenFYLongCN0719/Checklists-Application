//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by 龙富宇 on 2017/11/20.
//  Copyright © 2017年 AllenLong. All rights reserved.
//

import Foundation
import UIKit

protocol ItemDetailViewControllerDelegate: class {
    //搭建ChecklistViewController与ItemDetailViewController的通信桥梁。
    //protocol 协议。是一组方法的名称列表。表示：任何遵循这一协议的对象必须执行其中的方法。
    func itemDetailControllerDidCancel(_ controller: ItemDetailViewController)
    //用于用户点击Cancel时
    func itemDetailController(_ controller: ItemDetailViewController, didFinishadding item: ChecklistItem)
    //用于用户点击Done按钮时。在这个情况下，didFinishAdding参数会传递新的ChecklistItem对象。
    func itemDetailController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate{
    
//    五步定义委托
//    在两个对象之间创建委托可以用以下固定的步骤，比如对象A是对象B的委托，对象B发送消息返回给对象A，步骤如下：
//    1、在对象A中为对象B定义一个委托协议
//    2、给对象B一个可选型的委托变量，这个变量必须是weak的。
//    3、当某些事件触发时，让对象B发送消息到它的委托，比如用户点击Cancel或者Done按钮时，或者它需要一点信息时。你可以用语句delegate?.methodName(self,...)来完成这个功能。
//    4、让对象A遵守委托协议。将协议的名称放入类声明，class的哪一行，并且执行协议中的方法列表。
//    5、告诉对象B，对象A现在是你的委托了。

    weak var delegate: ItemDetailViewControllerDelegate?
    //weak 描述委托和视图控制器的关系。叫做“弱引用”。 在这里ChecklistViewController强引用ItemDetailViewController,而ItemDetailViewController弱引用ChecklistViewController
    // ? 代表委托时可选型
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var itemToEdit: ChecklistItem?
    //这个变量包含用户准备编辑的ChecklistItem对象。但是当新增一个待办项目时，itemToEdit会是nil，这就是视图控制器如何区分新增和编辑的。
    //所以它必须时可选型的。这个就是问号的作用。
    
    var dueDate = Date()
    
    var datePickerVisible = false
    //添加一个新的实例变量来跟踪时间选择器是否可见
    
    @IBAction func cancel(){
        //IBAction永远不返回值
//        dismiss(animated: true, completion: nil )
        delegate?.itemDetailControllerDidCancel(self)
        //这里的问号表示如果delegate为nil的话就不要发送消息，存在则发送消息。这叫 “可选型链接”
    }
    
    @IBAction func done(){
//        print("Contents of the text filed: \(textField.text!)")
//        dismiss(animated: true, completion: nil)
        
        if let item = itemToEdit {
            //首先检查itemToEdit是否包含一个对象，然后使用if let进行解包
            item.text = textField.text!
            //不为空则在文本框中放入一条已经存在的ChecklistItem对象
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            
            delegate?.itemDetailController(self, didFinishEditing: item)
            //调用didFinishEditing方法
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            
            delegate?.itemDetailController(self, didFinishadding: item)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            //当itemToEdit不为nil时.
            //又因为itemToEdit是一个可选型变量，所以必须使用if let进行使用可选型变量，并对其进行解包
            title = "Edit Item"
            //改变导航栏名称为“Edit Item”
            textField.text = item.text
            doneBarButton.isEnabled = true
            
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
    }
    
    //table view的委托方法。当用户点击某一行时，table view发送一个“willSelectRowAt”的委托，意思是“我马上要选择这一行了”。
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        //“？“和”！“在这里代表允许返回空值
        return nil
        //委托通过返回nil这个特殊的值来禁用这一行，它的意思是“对不起，你不能这样做”
        //nil这个特殊的值在这里代表的就是”没有值“
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            //if语句检查cellForRowAt是否被date picker的indexPath调用。如果是，它返回你刚设计的的datePickerCell。
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)-> Bool {
        //ShoudchangCharactersIn: 判定范围
        //replacementString: 判定字符串获取新的字符串并覆盖
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        //首先判断新的文本内容，NSString是OC的存储文本的对象。因为要使用NSString的replacingCharacters(in:with:)方法，所以必须使用NSString
        
        //            if newText.length > 0 {
        //                doneBarButton.isEnabled = true
        //            } else {
        //                doneBarButton.isEnabled = false
        //            }
        
        doneBarButton.isEnabled = (newText.length > 0)
        
        //            if some condition {
        //                something = true
        //            } else {
        //                something = false
        //            }
        
        //            可替换为
        
        //            something = (some condition)
        return true
    }
    
    func updateDueDateLabel() {
        let formtter = DateFormatter()
        //使用DateFormatter来将日期转换为文本
        formtter.dateStyle = .medium
        //将date部分设置一个风格
        formtter.timeStyle = .short
        //time部分设置另外一个风格，并且从中获得格式好的Date对象
        dueDateLabel.text = formtter.string(from: dueDate)
    }
    
    func showDatePicker() {
        datePickerVisible = true
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
    }
    
    
}
