//
//  ViewController.swift
//  Checklist
//
//  Created by Naver on 2020/10/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        title = checklist.name
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem"{
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        }else if segue.identifier == "EditItem"{
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.item = checklist.items[indexPath.row]
            }
        }
    }
    
    
    //MARK:- Help Method
    func configureText(for cell: UITableViewCell, with item: ChecklistItem){
        let label1 = cell.viewWithTag(1000) as! UILabel
        let label2 = cell.viewWithTag(1002) as! UILabel
        label1.text = item.text
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        label2.text = "\(formatter.string(from: item.dueDate))"
//        label.text = "\(item.itemID)"
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked{
            label.text = "√"
        }else{
            label.text = ""
        }
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           checklist.items.remove(at: indexPath.row)
           let indexPaths = [indexPath]
           tableView.deleteRows(at: indexPaths, with: .automatic)
       }
    
    
    //MARK:- Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
        configureCheckmark(for: cell, with: item)
        configureText(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//遵循ItemDetailViewControllerDelegate协议, item添加按duedate排序的逻辑
extension ChecklistViewController: ItemDetailViewControllerDelegate{
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        checklist.items.append(item)
        checklist.items.sort{
            item1, item2 in
            return item1.dueDate > item2.dueDate
        }
        let index = checklist.items.firstIndex(of: item)!
//        tableView.reloadData()
        let indexPath = IndexPath(row: index, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        checklist.items.sort{
            item1, item2 in
            return item1.dueDate > item2.dueDate
        }
        if let index = checklist.items.firstIndex(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: item)
            }
        }
//        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}


