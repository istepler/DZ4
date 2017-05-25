//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Kirill Kirikov on 5/14/17.
//  Copyright © 2017 GoIT. All rights reserved.
//

import UIKit

private enum ToDoItemPriority:Int {
    case normal
    case low
    case high
    
    func color() -> UIColor {
        switch self {
        case .high:
            return .red
        case .low:
            return .blue
        case .normal:
            return UIColor(red: 5/255, green: 225/255, blue: 119/255, alpha: 1)
        }
    }
}

private protocol ToDoItem {
    var title:String {
        get
        set
    }
    
    var priority:ToDoItemPriority {
        get
    }
    
    var icon:UIImage {
        get
    }
}

extension ToDoItem {
    func capitalizedTitle() -> String {
        return title.capitalized
    }
}

private class BaseToDoItem: NSObject, ToDoItem, NSCoding {
    
    var icon: UIImage {
        get {
            return #imageLiteral(resourceName: "icon_0")
        }
    }
    
    var title: String
    var priority: ToDoItemPriority
    
    override init() {
        self.title = ""
        self.priority = .normal
    }
    
    required init(title: String, priority: ToDoItemPriority) {
        self.title = title
        self.priority = priority
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: "title") as? String ?? ""
        self.priority = ToDoItemPriority(rawValue: aDecoder.decodeInteger(forKey: "priority"))!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(priority.rawValue, forKey: "priority")
    }
}

private class ClassworkToDoItem: BaseToDoItem {
    override var icon: UIImage {
        get {
            return #imageLiteral(resourceName: "icon_2")
        }
    }
}

private class HomeworkToDoItem: BaseToDoItem {
    override var icon: UIImage {
        get {
            return #imageLiteral(resourceName: "icon_0")
        }
    }
}

private class GameToDoItem: BaseToDoItem {
    override var icon: UIImage {
        get {
            return #imageLiteral(resourceName: "icon_1")
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var items:[ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTouchNewItem(_ sender: Any) {
        let alert = UIAlertController(title: "Create New Item", message: "What kind of item do you want to create?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Classwork", style: .default, handler: { (action:UIAlertAction) in
            self.addItem(item: ClassworkToDoItem(title: "", priority: .normal))
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Homework", style: .default, handler: { (action:UIAlertAction) in
            self.addItem(item: HomeworkToDoItem(title: "", priority: .normal))
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Game", style: .default, handler: { (action:UIAlertAction) in
            self.addItem(item: GameToDoItem(title: "", priority: .normal))
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("NumberOfRowsInSetion: \(section)")
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("CellForRowAt: \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ToDoItemTableViewCell
        
        cell.titleTextField.text = items[indexPath.row].capitalizedTitle()
        cell.priorityView.backgroundColor = items[indexPath.row].priority.color()
        cell.iconImageView.image = items[indexPath.row].icon
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        let alert = UIAlertController(title: "Are you sure?", message: "Do you want to delete \(item.capitalizedTitle())", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        
        //self.removeItem(at: indexPath.row)
        //tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    fileprivate func addItem(item: ToDoItem) {
        items.append(item)
        save()
    }
    
    fileprivate func removeItem(at index:Int) {
        items.remove(at: index)
        save()
    }
    
    fileprivate func load() {
        guard let loadedData = NSKeyedUnarchiver.unarchiveObject(withFile: "/Developer/projects/ToDoList.bin") as? [ToDoItem] else {
            return
        }
        items = loadedData
    }
    
    fileprivate func save() {
        let result = NSKeyedArchiver.archiveRootObject(items, toFile: "/Developer/projects/ToDoList.bin")
        print("Archive Result: \(result)")
    }
}

extension ViewController: ToDoItemTableViewCellDelegate {
    func cellWasChanged(cell:ToDoItemTableViewCell) {
        guard let indexPath = self.tableView?.indexPath(for: cell) else {
            return
        }
        
        items[indexPath.row].title = cell.titleTextField.text ?? ""
        save()
    }
}

extension ViewController: UITableViewDelegate {
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ToDoItemTableViewCell else {
            return
        }
    }
}







