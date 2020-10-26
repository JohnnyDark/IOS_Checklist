//
//  ItemDetailViewController.swift
//  Checklist
//
//  Created by Naver on 2020/10/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: AnyObject{
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var item: ChecklistItem?
    weak var delegate: ItemDetailViewControllerDelegate?
    var dueDate = Date()
    var shouldRemind = false
    var isDatePickerVisiable = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = item{
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            dueDate = item.dueDate
            shouldRemind = item.shouldRemind
            shouldRemindSwitch.isOn = shouldRemind
        }
        updateDueDateLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    //MARK:- Helper Method
    
    func updateDueDateLabel(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    func showDatePicker(){
        isDatePickerVisiable = true
        let datePickerCellIndexPath = IndexPath(row: 2, section: 1)
        datePicker.setDate(dueDate, animated: true)
        dueDateLabel.textColor = dueDateLabel.tintColor
        tableView.insertRows(at: [datePickerCellIndexPath], with: .fade)
    }
    
    func hideDatePicker(){
        if isDatePickerVisiable{
            isDatePickerVisiable = false
            let indexPath = IndexPath(row: 2, section: 1)
            tableView.deleteRows(at: [indexPath], with: .fade)
            dueDateLabel.textColor = UIColor.black
        }
    }
    
    
    //MARK:- Actions
    
    @IBAction func cancel(){
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(){
        if let item = item{
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        }else{
            let item = ChecklistItem(text: textField.text!)
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    @IBAction func changeDate(_ sender: UIDatePicker){
        dueDate = sender.date
        updateDueDateLabel()
    }
    
    @IBAction func shouldReminderToggle(_ sender: UISwitch){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound], completionHandler: {
            (granted, error) in
                //do something
        })
    }
}
    
//MARK:- Textfield Delegate

extension ItemDetailViewController{
    //监控输入框中的内容状态
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      let oldText = textField.text!
      let stringRange = Range(range, in:oldText)!
      let newText = oldText.replacingCharacters(in: stringRange,
                                              with: string)
      if newText.isEmpty {
        doneBarButton.isEnabled = false
      } else {
        doneBarButton.isEnabled = true
      }
      return true
    }
    
    //使用clear button
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker() //点击输入框输入内容时隐藏date picker
    }
}

//MARK:- 重写静态tableView的data source & delegate方法

extension ItemDetailViewController{
    //data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2{
            return datePickerCell
        }else{
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && isDatePickerVisiable{
            return 3
        }else{
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2{
            return 217
        }else{
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2{
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    //delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1{
            if !isDatePickerVisiable{
                showDatePicker()
            }else{
                hideDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1{
            return indexPath
        }else{
            return nil
        }
    }
}

