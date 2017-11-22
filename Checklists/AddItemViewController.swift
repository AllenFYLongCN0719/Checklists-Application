//
//  AddItemViewController.swift
//  Checklists
//
//  Created by 龙富宇 on 2017/11/20.
//  Copyright © 2017年 AllenLong. All rights reserved.
//

import Foundation
import UIKit

class AddItemViewController: UITableViewController, UITextFieldDelegate{
    
//    五步定义委托
//    在两个对象之间创建委托可以用以下固定的步骤，比如对象A是对象B的委托，对象B发送消息返回给对象A，步骤如下：
//    1、在对象A中为对象B定义一个委托协议
//    2、给对象B一个可选型的委托变量，这个变量必须是weak的。
//    3、当某些事件触发时，让对象B发送消息到它的委托，比如用户点击Cancel或者Done按钮时，或者它需要一点信息时。你可以用语句delegate?.methodName(self,...)来完成这个功能。
//    4、让对象A遵守委托协议。将协议的名称放入类声明，class的哪一行，并且执行协议中的方法列表。
//    5、告诉对象B，对象A现在是你的委托了。

    weak var delegate: AddItemViewControllerDelegate?
    //weak 描述委托和视图控制器的关系。叫做“弱引用”。 在这里ChecklistViewController强引用AddItemViewController,而AddItemViewController弱引用ChecklistViewController
    // ? 代表委托时可选型
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func cancel(){
        //IBAction永远不返回值
//        dismiss(animated: true, completion: nil )
        delegate?.addItemControllerDidCancel(self)
        //这里的问号表示如果delegate为nil的话就不要发送消息，存在则发送消息。这叫 “可选型链接”
    }
    
    @IBAction func done(){
//        print("Contents of the text filed: \(textField.text!)")
//        dismiss(animated: true, completion: nil)
        
        let item = ChecklistItem()
        item.text = textField.text!
        item.checked = false
        
        delegate?.addItemController(self, didFinishadding: item)
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
    
    
    
    
}
