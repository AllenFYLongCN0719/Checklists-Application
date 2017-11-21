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
    
    @IBOutlet weak var textField: UITextField!
    @IBAction func cancel(){
        //IBAction永远不返回值
        dismiss(animated: true, completion: nil )
    }
    
    @IBAction func done(){
        print("Contents of the text filed: \(textField.text!)")
        dismiss(animated: true, completion: nil)
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
