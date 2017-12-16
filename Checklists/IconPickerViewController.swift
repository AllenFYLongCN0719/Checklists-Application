//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by 龙富宇 on 2017/12/14.
//  Copyright © 2017年 AllenLong. All rights reserved.
//

import UIKit

    protocol IconPickerViewControllerDelegate: class {
        func IconPicker(_ picker: IconPickerViewController, didPick iconName: String)
    }
    
    class IconPickerViewController: UITableViewController {
        weak var delegate: IconPickerViewControllerDelegate?
        
        let icons = ["No Icon",
                     "cake"]
        
        override func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return icons.count
            //返回数组中的对象数量
        }
        
        override func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //这里得到一个table view cell并且给它一个文本和图片。
            let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
            let iconName = icons[indexPath.row]
            cell.textLabel!.text = iconName
            cell.imageView!.image = UIImage(named: iconName)
            
            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let delegate = delegate {
                let iconName = icons[indexPath.row]
                delegate.IconPicker(self, didPick: iconName)
            }
        }
    }
    


