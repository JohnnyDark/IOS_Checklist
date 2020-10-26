//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Naver on 2020/10/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UserNotifications

class Checklist: NSObject, Codable{
    var name: String
    var items: [ChecklistItem] = []
    var iconName = "No Icon"
    
    init(name: String, iconName: String = "No Icon"){
        self.name = name
        self.iconName = iconName
    }
    
    func countUncheckItems() -> Int{
        var count = 0
        for item in items where !item.checked{
            count += 1
        }
        return count
    }
}

class ChecklistItem: NSObject, Codable{
    var text = ""
    var checked  = false
    
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    init(text: String) {
        self.text = text
        itemID = DataModel.returnItemID()
    }
    deinit {
        removeNotification()
    }
    
    func toggleChecked(){
        checked = !checked
    }
    
    func scheduleNotification(){
        removeNotification()
        if shouldRemind && dueDate > Date(){
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil)
            print("schedule\(request) for itemId \(itemID)")
        }
    }
    
    func removeNotification(){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
}
