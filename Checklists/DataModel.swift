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
    
    //将UserDefaults相关的都移到DataModel中。
    var indexOfSelectedChecklist: Int {
        get {
            //当App试图读取值的时候，get内的代码将被执行
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            //当App试图写入一个新的值时，set内的代码将被执行
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init() {
        loadChecklist()
        //保证一旦DataModel对象被创建，它会去读取Checklists.plist.
        //然后去AllListsViewController.swift作出如下改动：
        //移除lists实例变量
        //移除init?(coder)方法
        //添加新的实例变量 var dataModel: DataModel
        //在AppDelegate里添加 dataModel = DataModel()
        
        registerDefaults()
        //调用方法。
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
    
    //添加新的字典实例，将-1添加到键值"ChecklistIndex"中
    func registerDefaults() {
        let dictionary: [String: Any] = ["ChecklistIndex": -1]
        //这里的方括号内容是字典而不是数组 [key1: value1, key2: value2, . .]
        UserDefaults.standard.register(defaults: dictionary)
        //当键中不存在值的时候，就会从这个字典中请求值。
        //然后修改init方法。
    }

    
}





