//
//  DataModel.swift
//  Checklists
//
//  Created by 龙富宇 on 2017/12/3.
//  Copyright © 2017年 AllenLong. All rights reserved.
//

//为Checklist和ChecklistItem创建顶级的数据模型对象

import Foundation

//定义一个新的数据模型对象并且给它了一个lists属性
class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadChecklist()
        //保证一旦DataModel对象被创建，它会去读取Checklists.plist.
        //然后去AllListsViewController.swift作出如下改动：
        //移除lists实例变量
        //移除init?(coder)方法
        //添加新的实例变量 var dataModel: DataModel
        //在AppDelegate里添加 dataModel = DataModel()
    }
    
    //从AllListsViewController.swift中剪切出来，再粘贴到DataModel.swift中
    func documeentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documeentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    //用于保存的方法现在叫做saveChecklists()
    func saveChecklist() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        //这里和之前不同
        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    //用于读取的方法现在叫做loadChecklists()
    func loadChecklist() {
        let path = dataFilePath()
        if let data = try?Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            //这里和之前的不同
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
        }
    }

    
}





