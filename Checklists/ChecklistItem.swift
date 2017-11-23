//
//  ChecklistItem.swift
//  Checklists
//
//  Created by 龙富宇 on 2017/11/18.
//  Copyright © 2017年 AllenLong. All rights reserved.
//

import Foundation
class ChecklistItem: NSObject {
    var text = "" //储存文本内容
    var checked = false //决定cell是否显示对勾符号
    
    func toggleChecked() {
        checked = !checked
        //将变量checked的相反值赋予checked
    }
}
