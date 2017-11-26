//
//  Checklist.swift
//  Checklists
//
//  Created by 龙富宇 on 2017/11/26.
//  Copyright © 2017年 AllenLong. All rights reserved.
//

import UIKit

class Checklist: NSObject {
    var name = ""
    
    //创建一个新的init方法，将name作为一个参数
    init(name: String) {
        self.name = name
        //因为参数名称和实例变量都叫做name，所以使用self.name来引用实例变量。这里self是引用当前所处的对象。
        super.init()
    }
}
