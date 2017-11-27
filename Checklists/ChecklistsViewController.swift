//
//  ViewController.swift
//  Checklists
//
//  Created by 龙富宇 on 2017/11/18.
//  Copyright © 2017年 AllenLong. All rights reserved.
    //

//Accessory在table view cell(TableView->ChecklistItem)的属性面板里 in storyboard。

import UIKit



class ChecklistViewController: UITableViewController,ItemDetailViewControllerDelegate {
    //添加ItemDetailViewControllerDelegate让ChecklistViewController承诺执行ItemDetailViewControllerDelegate协议中的内容
    
    var items: [ChecklistItem]
    //这一行声明了items会用来存储一个ChecklistItem对象的数组
    //但是它并没有实际创建一个数组
    //在这一时刻，items还没有值
    
    var checklist: Checklist!
    
    
    required init?(coder aDecoder: NSCoder) {
        //对象的init方法或初始化器
        items = [ChecklistItem]()
        //创建数组对象
        //这一行实例化了这个数组。现在items包含了一个有效的数组对象
        //但是这个数组内部还不存在ChecklistItem对象
        
        let row0item = ChecklistItem()
        //这一行实例化了一个新的ChecklistItem对象。注意这里有一对圆括号
        
        row0item.text = "Walk the dog"
        row0item.checked = false
        //给这个新的ChecklistItem对象内部的数据项赋值。
        
        items.append(row0item)
        //这一行负责将ChecklistItem对象添加到数组中去。
        
        let row1item = ChecklistItem()
        row1item.text = "Brush my teeth"
        row1item.checked = true
        items.append(row1item)
        
        let row2item = ChecklistItem()
        row2item.text = "Learn iOS development"
        row2item.checked = true
        items.append(row2item)
        
        let row3item = ChecklistItem()
        row3item.text = "Soccer practice"
        row3item.checked = false
        items.append(row3item)
        
        let row4item = ChecklistItem()
        row4item.text = "Eat ice cream"
        row4item.checked = true
        items.append(row4item)
        
        let row5item = ChecklistItem()
        row5item.text = "1Eat ice cream"
        row5item.checked = false
        items.append(row5item)
        
        let row6item = ChecklistItem()
        row6item.text = "2Eat ice cream"
        row6item.checked = true
        items.append(row6item)
        
        super.init(coder: aDecoder)
        //调用了父级的init()。调用super.init(coder)，确保这个视图控制器的剩余部分可以正常的从故事模版中解码。
        loadChecklistItems()
        //调用其他的方法，这里是调用了一个新的方法，这个新方法的作用是从plist文件中读取数据。
        
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
    }
    
    func saveChecklistItem() {
        let data = NSMutableData()
        //数据被放置在一个NSMutableData对象中。
        let archiver = NSKeyedArchiver(forWritingWith: data)
        //NSCoder创建plist文件的形式，将数组编码（encode）并且将其中的所有ChecklistItem转换为二进制格式，这样就可以将这些数据写入文件了。
        archiver.encode(items, forKey: "ChecklistItems")
        //调用encode(with)需要在ChecklistItem.swift里添加NSCoding
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
        //将自己写入dataFilePath()路径指定的文件中。
    }
    
    func loadChecklistItems() {
        //1 将dataFilePath()的结果放到一个名叫path的临时常量中
        let path = dataFilePath()
        //2 试着从Checklists.plist中读取内容到一个新的数据对象中。关键字Try？的意思是“试试”，如果有数据对象就读出来，如果是nil就不读。所以这就是用if let解包的原因。
        if let data = try?Data(contentsOf: path){
            //3 当app找到Checklists.plist文件，读取整个数组，创建一个NSKeyedUnarchiver对象，也就是unarchiver，并且要求它将数据解码到items数组中。
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
            //这一步将文件中曾经未解码的ChecklistItem对象的拷贝填充到数组中。
            unarchiver.finishDecoding()
        }
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem){
        //创建方法单独进行处理对勾。
        //with是参数外部名称，item是参数内部名称
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if  item.checked{
            label.text = "√"
        } else{
            label.text = ""
        }
        
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem){
        //创建方法单独进行处理文字。
        let label = cell.viewWithTag(1000) as! UILabel //表格一定会有一个以上的cell，每个cell都会有自己的label，如果使用outlet链接viewcontroller，那么这个outlet只能引用其中一个cell的label
        label.text = item.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
        //执行转场时，会将这个checklist对象给到ChecklistViewController,也就是将导航栏的标题修改为Checklist对象的名称。
        //与此同时在AllListController.swift中，将tableView(didSelectRowAt)进行修改。
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //创建用户内容的文档文件夹的地址
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //使用documentsDirectory()的返回结果构建了路径到存储办事项清单的文件。文件的名称是Checklists.plist，并且这个文件存储在文档目录中。
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    

    
    
    //data source(数据源)与table view交互。 获得数据源里的内容数量
    override func tableView(
        //第一个方法
        _ tableView: UITableView,                   //参数1 不需要外部名，所以使用 "_ tableView"
        numberOfRowsInSection section: Int)         //参数2 numberOfRowsInSection是参数的外部名称，Section是参数的内部名称，冒号后面的是参数的类型
        -> Int { //返回值类型跟在 -> 后                //返回值
        return items.count                          //根据item
    }
    
    //得到一行数据后，调用第二个方法，将row data放入cell中
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //tableView(cellForRowAt)来获得位这一行准备好的cell || IndexPath是数据源的本体，包含两个信息的参数
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[indexPath.row]
        //访问items,也就是[ChecklistItem]中的属性indexPath.row
        configureText(for: cell, with: item)
        //处理string
        configureCheckmark(for: cell, with: item) //调用方法必须使用外部名称
        //处理cell
        return cell //返回到table view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView(didSelectRowAt)方法是tableView的delegate method(委托方法)的一种
            // tableView.cellForRow(at)和tableView(cellForRowAt)是不一样的
            // 前者是返回一个cell对象，但是是一个正在显示的某一行中的一个已存在的cell，他不会创建一个新的cell。
            // 后者是传递一个新的cell对象到table view。
        
        
                if let cell = tableView.cellForRow(at: indexPath){
                    let item = items[indexPath.row]
                    item.toggleChecked()

                configureCheckmark(for: cell, with: item)
                }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItem()
        //该方法修改了items数组，所以需要调用保存方法
        }
    
    //使用prepare(for: sender: )可以使你在新的视图控制器展现前向它发送数据。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //这里是告诉ItemDetailViewController现在ChecklistViewController时它的委托了。
        
        //1 因为前一个视图控制器可能具有多个转场，所以最好给每一个转场赋予一个独一无二的名称以区分它们，并且每次操作前先检查是不是正确的转场。swift中的“==”等于比较符，不仅用于数字，也可以用于字符串和大多数类型的对象。
        if segue.identifier == "AddItem"{
        //在故事模版中的两个页面中间的转场icon的属性检查器中找到Identifier并且键入"AddItem"
            
        //2 新的视图控制器可以通过segue.destination被找到。故事模版中转场并不是直接指向ItemDetailViewController，而是指向包含它的导航控制器（navigation controller）。因此首先你要抓取到这个UINavigationController对象。
        let navigationController = segue.destination as! UINavigationController
        
        //3 为了找到ItemDetailViewController，你可以查看导航控制器的顶层视图（topViewController）属性。这个属性正是引用目前被嵌入导航控制的界面。
        let controller = navigationController.topViewController as! ItemDetailViewController
        
        //4 一旦你有了一个指向ItemDetailViewController的引用，你设置它的delegate属性到self，至此这个链接就完毕了。从现在起ItemDetailViewController就知道了，这个self指代的对象就是它的委托。当你在ChecklistViewController.swift中写了self时，这个self就指代ChecklistViewController。
            controller.delegate = self
        } else if segue.identifier == "EditItem"{
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                //设置了一个UITableViewCell对象用于定位被点击的那一行的行号相对应的index-path，通过使用tableView.indexPath(for:)
                //tableView.indexPath(for:)的返回类型为IndexPath?，是一个可选型，这就意味着它可能返回nil。这就是为什么在你使用它前需要用if let来解包的原因。
                controller.itemToEdit = items[indexPath.row]
                //将获取的行数放入itemToEdit
            }
        }
        
    }
    
    //添加从右向左滑的删除功能
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //commit editingStyle会激活滑动删除功能
        items.remove(at: indexPath.row)
        //从数据模型中移除掉这条数据
        let indexPaths = [indexPath]
        //使用一个额临时数组保存index—path对象，也就是这一行
        tableView.deleteRows(at: indexPaths, with: .automatic)
        //告诉table view删除这一行
        saveChecklistItem()
        //该方法修改了items数组，所以需要调用保存方法
    }
    
    //已经被ItemDetailViewController(didFinishadding)所替代
    //加号的动作方法
//    @IBAction func addItem() {
//        let newRowIndex = items.count
//        //需要计算新加行在数组中的索引index编号，使table view正确的更新新的一行
//        //将新的一行的index放到局部常量newRowIndex中。
//
//        let item = ChecklistItem()
//        //创建一个新的ChecklistItem
//        item.text = "I am a new row"
//        item.checked = false
//        //添加新的string和cell
//        items.append(item)
//        //将新的对象添加到数据模型的数组中去，也就是ChecklistItem()
//
//        let indexPath = IndexPath(row: newRowIndex,section: 0)
//        //使用Index-Path来标示行号，所以使用一个indexPath对象来标示这个新的行。所以这里是使用newRowIndex的值。
//        let indexPaths = [indexPath]
//        //创建一个临时的数组[indexPath]来保存刚才生成的indexPath,并放在局部常量indexPaths中。
//
//        tableView.insertRows(at: indexPaths, with: .automatic)
//        //务必必须告诉table view有新的数据。因为数据模型与视图必须保持同步。
//        //使用insertRows来告诉table view添加新的一行。但是方法名称Rows是复数，意味着可以通过这个方法，一次性添加许多行。
//        //最后通知table view插入新的这一行，参数"with: .automatic"参数的作用是：使table view插入新行时，闪现一个动画。
//
//
//    }
    
    //将ItemDetailViewControllerDelegate协议中的方法加入ChecklistViewController
    func itemDetailControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    //将新的ChecklistItem添加到数据模型和table view中
    func itemDetailController(_ controller: ItemDetailViewController, didFinishadding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        //添加到数据模型
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        //添加到table view
        
        dismiss(animated: true, completion: nil)
        saveChecklistItem()
        //该方法修改了items数组，所以需要调用保存方法
    }
    
    //添加新的协议内容itemDetailController(didFinishEditing)
    func itemDetailController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = items.index(of: item) {
            //你需要从cell中读取所需的IndexPath，首先你就需要寻找到ChecklistItem对象的行号。行号和ChecklistItem在items数组中的索引值是一致的，然后你通过index(of)方法来返回这个index。
            //因为不能在任意对象上使用index(of)，只能在“相同”的对象上使用它。index(of)以某种方式对你在数组中寻找的对象进与调用它的对象行比较，看看它们是否相等。
            //所以第一种方式是在ChecklistItem.swift中添加"NSObject"进行比较。将ChecklistItem建立在NSObject之上，就可以使它安全的进行比较了。
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
        saveChecklistItem()
        //该方法修改了items数组，所以需要调用保存方法
    }
    
    
}

