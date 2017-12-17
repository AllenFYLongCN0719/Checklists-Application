//
//  Checklist.swift
//  Checklists
//
//  Created by 龙富宇 on 2017/11/26.
//  Copyright © 2017年 AllenLong. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    var name = ""
    var items = [ChecklistItem]()
    //创建数组存放checklist item
    //然后打开ChecklistViewController.swift，删掉items实例变量以及修改相关调用
    //以及删除func documentsDirectory(), func dataFilePath(), func saveChecklistItems(), func loadChecklistItems().
    //然后把调用saveChecklistItems()的行删掉，同时也把init?(coder)删掉。
    
    //创建一个新的init方法，将name作为一个参数
        convenience init(name: String) {
//        //便利初始化。将一部分工作交给了另一个init方法
//        self.name = name
//        //因为参数名称和实例变量都叫做name，所以使用self.name来引用实例变量。这里self是引用当前所处的对象。
//        iconName = "No Icon"
//        //给所有新的checklist一个默认“No Icon”图标。
//        super.init()
        self.init(name: name, iconName: "No Icon")

    }
    
    //添加NSCoding协议的两个方法
    //从plist读取对象
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
    
    //同时需要名称及图表名称
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
        //添加iconName
    }
    //完成这个步骤之后需要删除文件夹中的.plist文件
    
    //计数待办事项
    func countUnCheckedItems() -> Int {
        //向任何Checklist对象请求其中还没有被打上对勾符号的待办事项的数量，最后返回一个整数型的值。
        var count = 0
        for item in items where !item.checked{
            //使用for循环历遍items数组中的ChecklistItem对象。如果一个item对象的checked属性被设置为false，你就将局部变量count加1.
            //这里!item.checked是取反。
            count += 1
        }
        return count
    }
    
    var iconName: String
    
}
