//
//  ListDetailViewController.swift
//  Checklist
//
//  Created by Naver on 2020/10/21.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    var iconName = "Folder" //设置默认的icon name
    var checklistToEdit: Checklist?
    weak var delegate: ListDetailViewControllerDelegate?

    override func viewDidLoad() {
        if let checklist = checklistToEdit{
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
            iconName = checklist.iconName
        }else{
            title = "Add new Checklist"
        }
        imageView.image = UIImage(named: iconName)
        navigationItem.largeTitleDisplayMode = .never
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    //MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon"{
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    //MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }
    
    @IBAction func cancel(){
        delegate?.listDetailViewControllerDidCancel(self)
    }
    @IBAction func done(){
        if let checklist = checklistToEdit{
            checklist.name = textField.text!
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        }else{
            let checklist = Checklist(name: textField.text!, iconName:iconName)
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
}

//MARK:- 实现textField的代理方法
extension ListDetailViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange,
                                                  with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
//MARK:- 实现IconPicker的代理方法
extension ListDetailViewController: IconPickerViewControllerDelegate{
    func iconPicker(_ controller: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        imageView.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }
    
    
}


