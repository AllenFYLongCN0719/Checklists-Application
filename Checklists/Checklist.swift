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
    init(name: String) {
        self.name = name
        //因为参数名称和实例变量都叫做name，所以使用self.name来引用实例变量。这里self是引用当前所处的对象。
        super.init()
    }
    
    //添加NSCoding协议的两个方法
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
    }
    //完成这个步骤之后需要删除文件夹中的.plist文件
}
