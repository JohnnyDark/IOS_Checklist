//
//  AllListsViewController.swift
//  Checklist
//
//  Created by Naver on 2020/10/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {
    
    let cellIdentifier = "ChecklistCell"
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        //代码创建cell对象
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationController?.navigationBar.prefersLargeTitles = true
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //设置navigationController的代理对象
        navigationController?.delegate = self
//        let index = UserDefaults.standard.integer(forKey: "ChecklistIndex")
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count{
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData() //通过该方法重新获取任何操作更新后的数据
    }
    
    
    
    //MARK:- Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let checklist = dataModel.lists[indexPath.row]
        let cell: UITableViewCell!
        if let c = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            cell = c
        }else{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        cell.textLabel!.text = dataModel.lists[indexPath.row].name
        cell.accessoryType = .detailDisclosureButton
        
        let count = checklist.countUncheckItems()
        if checklist.items.count == 0{
            cell.detailTextLabel!.text = "(No Items)"
        }else{
            cell.detailTextLabel!.text = count != 0 ? "\(count) Remaining" : "All Done!"
        }
        cell.imageView!.image = UIImage(named: checklist.iconName)
        return cell
    }
    
    //MARK:- Table View Delegate 记录退出前停留的界面
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        UserDefaults.standard.set(indexPath.row, forKey: "ChecklistIndex")
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    //MARK:- 使用storyboard来创建view controller，用代码实现点击accessoryButton执行segue
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(identifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        controller.checklistToEdit = dataModel.lists[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist"{
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        }else if segue.identifier == "AddChecklist"{
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }else if segue.identifier == "EditChecklist"{
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = sender as? Checklist
        }
    }
    //MARK:- Help Method
    func configureText(for cell: UITableViewCell, with checklist: Checklist){
        cell.textLabel!.text = checklist.name
    }
}

extension AllListsViewController: ListDetailViewControllerDelegate{
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
//        let index = dataModel.lists.count
        dataModel.lists.append(checklist)
        dataModel.sortLists()
//        let indexPaths = [IndexPath(row: index, section: 0)]
//        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        dataModel.sortLists()
//        if let index = dataModel.lists.firstIndex(of: checklist), let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)){
//            configureText(for: cell, with: checklist)
//        }
        navigationController?.popViewController(animated: true)
    }
}

extension AllListsViewController: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self{ //从ChecklistViewController界面返回到AllListViewController界面，则无需保存index
//            UserDefaults.standard.set(-1, forKey: "ChecklistIndex")
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}

