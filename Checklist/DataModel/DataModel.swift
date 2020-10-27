//
//  DataModel.swift
//  Checklist
//
//  Created by Naver on 2020/10/22.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

class DataModel{
    
    var lists = [Checklist]()
    
    //MARK:- 计算属性处理userdefaults中数据的存取逻辑
    var indexOfSelectedChecklist: Int{
        get{
            UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        
        set{
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    //MARK:- Document目录和数据文件目录处理
    func documentsDirectory() -> URL{
       let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
       return paths[0]
   }
   
   func dataFilePath() -> URL{
       return documentsDirectory().appendingPathComponent("Checklists.plist")
   }
   
   //MARK:- 数据保存和数据加载
   func saveChecklists(){
       let encoder = PropertyListEncoder()
       do {
           let data = try encoder.encode(lists)
           try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
       } catch  {
           print(error.localizedDescription)
       }
   }

   func loadChecklists(){
       let path = dataFilePath()
       if let data = try? Data(contentsOf: path){
        print("开始加载数据")
           let decoder = PropertyListDecoder()
           do {
               lists = try decoder.decode([Checklist].self, from: data)
               sortLists()
           } catch  {
               print(error.localizedDescription)
           }
       }
   }
    //Userdefaults中添加默认值
    func registerDefaults(){ //为userdefault中的key设置默认值ChecklistIndex没有被主动设置值时，此时取这个key返回默认值
        let dictory = ["ChecklistIndex": -1, "FirstTime": true] as [String: Any] //类型提升
        UserDefaults.standard.register(defaults: dictory)
    }
    
    func handleFirstTime(){
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        if firstTime{ //如果是首次启动，添加一个默认的Checklist对象
            lists.append(Checklist(name: "List"))
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
    func sortLists(){
        lists.sort(by: {(list1, list2) in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
        )
    }
    
    //创建item的id，使用此id来创建item对应的Notification，作为它的identifier
    class func returnItemID() -> Int{
        let userDefaults = UserDefaults.standard
        let itemId = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemId+1, forKey: "ChecklistItemID")
        userDefaults.synchronize() // 将修改后的值立即写回去
        return itemId
    }
}
