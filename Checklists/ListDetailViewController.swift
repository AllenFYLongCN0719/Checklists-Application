//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by 龙富宇 on 2017/11/27.
//  Copyright © 2017年 AllenLong. All rights reserved.
//

//添加和编辑待办事项分类功能

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController,didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController,didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    func IconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        let _ = navigationController?.popViewController(animated: true)
        //因为转场使用的是Show而不是present modally，所以要使用pop
        //通过let _=告诉Xcode不需要关心popViewController()的返回结果，下划线叫做通配符
    }
    
//静态cell的UITableViewController
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    
    var iconName = "cake"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            //当用户编辑已经存在的待办事项分类时，可以将界面的标题修改为Edit Checklist
            textField.text = checklist.name
            //将修改的待办事项分类的名称放入text field
            doneBarButton.isEnabled = true
            iconName = checklist.iconName
        }
        iconImageView.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //自动弹出小键盘
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    //给按钮Cancel和Done按钮添加动作方法
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    //告诉IconPickerViewController，PickIcon是它的委托
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    @IBAction func done() {
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!, iconName: iconName)
            //被选择的icon name放入Checklist对象
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
    //确保用户无法选择textfield所在行的cell
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1{
            return indexPath
        } else {
            return nil
        }
    }
    
    //添加text field的委托方法，根据用户的输入是否为空来启用或禁用Done按钮。然后在故事面板添加Navigation Controller.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //按住ctrl将Text Field拖拽到视图控制器上，在弹出窗口中选择delegate。这样这个视图控制器就是text field的委托了。
        //还需要在控件Text Field关系列表里的referencing Outlets添加与本方法的连接。选择New Referencing Outlet然后与黄色图标连接，选择textField。
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    
    
    
    
}


