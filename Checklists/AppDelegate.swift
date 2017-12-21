//
//  AppDelegate.swift
//  Checklists
//
//  Created by 龙富宇 on 2017/11/18.
//  Copyright © 2017年 AllenLong. All rights reserved.
//

import UIKit
import UserNotifications
//本地通知框架

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // UIWindow是app中所有视图中最高级的视图，在app中仅存在一个UIWindow
    
    let dataModel = DataModel()

    
    //向AllListsViewController分享DataModel实例最佳的地方.这个方法在app一启动时就会被调用。
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let navigationController = window!.rootViewController as! UINavigationController
        let controller = navigationController.viewControllers[0] as! AllListsViewController
        controller.dataModel = dataModel
        
        //调用本地通知
        let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert,.sound], completionHandler: {
                    granted,error in
                    if granted {
                        print("We have permission")
                    } else {
                        print("Permission deied")
                    }
                })
        
        let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.body = "I am a local notifcation"
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger (timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "MyNotification", content: content, trigger: trigger)
        center.add(request)
        //创建了一个新的本地通知，因为timeInterval: 10，所以这个通知会在app运行10秒后被触发
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    //进入
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveData()
        //调用saveData()方法
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    //终止
    func applicationWillTerminate(_ application: UIApplication) {
        saveData()
        //调用saveData()方法
    }
    
    //添加存储的方法。
    func saveData() {
        let navigationController = window!.rootViewController as! UINavigationController
        //确保一个可选型不会为nil,所以在解包时，可以进行强行解包。
        //向UIWindow的rootViewController请求访问
        let controller = navigationController.viewControllers[0] as! AllListsViewController
        //因为UINavigationController没有自己的"rootViewController"，所以需要使用以上代码从视图控制器的数组中找到它。
        dataModel.saveChecklist()
        //调用saveChecklist()方法。
    }
    
    
}

