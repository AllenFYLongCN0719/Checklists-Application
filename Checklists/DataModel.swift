//
//  DataModel.swift
//  Checklists
//
//  Created by 龙富宇 on 2017/12/3.
//  Copyright © 2017年 AllenLong. All rights reserved.
//

//为Checklist和ChecklistItem创建顶级的数据模型对象DataModel

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
        
        handleFirstTime()
        //新增调用方法。
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
        sortChecklists()
        //确保存在的条目也被同样的规则排序。所以需要当plist文件被加载时也调用了个这个方法。
    }
    
    //添加新的字典实例，将-1添加到键值"ChecklistIndex"中
    //添加新的设置"FirstTime",检查用户是否首次运行app
    func registerDefaults() {
        let dictionary: [String: Any] = ["ChecklistIndex": -1, "FirstTime": true]
        //这里的方括号内容是字典而不是数组 [key1: value1, key2: value2, . .]
        //“FirstTime”跟踪用户是否首次运行app
        UserDefaults.standard.register(defaults: dictionary)
        //当键中不存在值的时候，就会从这个字典中请求值。
        //然后修改init方法。
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
    
        if(firstTime){
            //使用UserDefaults来检查“FirstTime”的值，如果为true，那么就是app第一次运行
            lists.append(Checklist(name: "ListOne"))
            //创建一个新的Checklist对象到数组中去
            indexOfSelectedChecklist = 0
            //设置索引为0，用作Checklist对象的索引，来保证app会自动通过AllListsViewController的viewDidAppear()方法转场到新的列表上。
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
        
    }
    
    func sortChecklists() {
        lists.sort(by: {
            //告知lists数组Checklists的内容要以某种准则排序。
            //这个准则又闭包提供，也就是花括号内的排序代码。
            checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending
            //判断一个Checklist对象是否应该排在另一个之前。
            //localizedStandardCompare()方法会结合区域中的规则比较两个字符串
        })
    }
    
}





