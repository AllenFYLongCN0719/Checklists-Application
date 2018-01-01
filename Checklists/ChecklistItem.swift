//
//  ChecklistItem.swift
//  Checklists
//
//  Created by 龙富宇 on 2017/11/18.
//  Copyright © 2017年 AllenLong. All rights reserved.
//

import Foundation
import UserNotifications
//导入通知框架。

class ChecklistItem: NSObject,NSCoding {
    //添加NSCoding后需要添加encode的方法，以此遵守协议。
    //NSCoding协议中的方法是 func encode(with aCoder: NSCoder) 和 init?(coder aDecoder: NSCoder)
    var text = "" //储存文本内容
    var checked = false //决定cell是否显示对勾符号
    
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    func toggleChecked() {
        checked = !checked
        //将变量checked的相反值赋予checked
    }
    
    //第一个协议方法。
    func encode(with aCoder: NSCoder) {
    //本方法是用于存储或者说用于编码的方法。
        //当NSKeyedArchiver试图对ChecklistItem对象编码时，它会先给Checklist item发送一条encode(with)消息
        aCoder.encode(text, forKey: "Text")
        //一个ChecklistItem需要保存一个名叫Text的对象，这个对象包含实例变量text的值
        aCoder.encode(checked, forKey: "Checked")
        //一个名为Checked的对象，这个对象包含变量checked的值
        aCoder.encode(itemID, forKey: "ItemID")
        aCoder.encode(shouldRemind, forKey:"ShouldRemind")
        aCoder.encode(dueDate, forKey:"DueDate")
    }
    
    //第二个协议方法 做与encode(with)相反的操作。从NSCoder的解码对象中取得了对象并且将它们放回到原来的变量中。
    required init?(coder aDecoder: NSCoder) {
        //当init可能会返回失败或者是nil时，需要加上一个问号。可以理解为一个对象解码时，plist文件中的数据丢失，导致解码失败
        text = aDecoder.decodeObject(forKey: "Text") as! String
        //存储在Text中的内容现在重新回到text变量中。这里对text操作用的是decodeObject
        checked = aDecoder.decodeBool(forKey: "Checked")
        //对checked使用的是decodeBool。
        
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        
        super.init()
        //初始化对象
    }
    
    //当我们用到了init?(coder)，所以就必须写出init()
    override init(){
        itemID = DataModel.nextChecklistItemID()
        //给itemID分配一个值
        super.init()
    }
    
    //安排本地通知
    func scheduleNotification() {
        if shouldRemind && dueDate > Date() {
            //对比due date和当前时间，使用Date对象来获得当前时间。
            //语句dueDate>Date()比较两个时间后返回true和false
            
            //1 将item的文本放入通知中
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = text
            content.sound = UNNotificationSound.default()
            //2 从dueDate中提取月、日、小时和分钟。
            let calender = Calendar(identifier: .gregorian)
            let components = calender.dateComponents([.month,.day,.hour,.minute], from: dueDate)
            //3 使用Trigger来展示详细的时间
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            //4 创建UNNotificationRequest对象。
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            //5 添加新的通知到UNUserNotificationCenter
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("We should schedule a notification")
            
        }
    }
}
