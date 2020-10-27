//
//  IconPickerViewController.swift
//  Checklist
//
//  Created by Naver on 2020/10/22.
//  Copyright © 2020 Johnny. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate:AnyObject {
    func iconPicker(_ controller: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    
    let iconNames = ["No Icon", "Appointments", "Birthdays", "Chores",
      "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips"]
        
    weak var delegate: IconPickerViewControllerDelegate?
    var iconName: String!
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iconNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        let iconName = iconNames[indexPath.row]
//        cell.imageView!.image = UIImage(named: iconName)
//        cell.textLabel!.text = iconName
        configure(for: cell, with: iconName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.iconPicker(self, didPick: iconNames[indexPath.row])
    }
    
    //MARK:- Helper method
    func configure(for cell:UITableViewCell, with iconName: String ){
        cell.imageView!.image = UIImage(named: iconName)
        cell.textLabel!.text = iconName
        if self.iconName == iconName{
            cell.accessoryType = .checkmark
        }
    }
}
