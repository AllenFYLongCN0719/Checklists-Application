//
//  AddItemViewController.swift
//  Checklists
//
//  Created by 龙富宇 on 2017/11/20.
//  Copyright © 2017年 AllenLong. All rights reserved.
//

import Foundation
import UIKit

class AddItemViewController: UITableViewController{
    
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
}
