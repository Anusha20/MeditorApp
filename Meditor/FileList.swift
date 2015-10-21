//
//  FileList.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/20/15.
//  Copyright © 2015 Meditor. All rights reserved.
//

import Foundation


let keyFileList = "fileList"

let currentId = "currentId"



var fileList : Dictionary = Dictionary<String,AnyObject>()

func setFileList(jo: Dictionary<String,AnyObject>){
/*var jo : [NSObject : AnyObject] = [
        "a" : "1.0",
        "b" : "2.0"
    ]*/
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setObject(jo, forKey: keyFileList)
    var isOk = userDefaults.synchronize()
}

func LoadFileList(){
    let userDefaults = NSUserDefaults.standardUserDefaults()
    if let res = userDefaults.dictionaryForKey(keyFileList){
        if !res.isEmpty{
            fileList = res as! Dictionary
        }
    }
   
}

func updateFileList(id:String,title:String){
    fileList[id]=title
    setFileList(fileList);
}

func getFileList() -> NSDictionary{
    if fileList.isEmpty{
        LoadFileList()
    }
    return fileList
}

func setCurrentMeditorDocId( value:String){
    let defaults = NSUserDefaults.standardUserDefaults()
    
    defaults.setValue(value, forKey: currentId)
    
    defaults.synchronize()
}

func getCurrentMeditorDocId()->String{
    let defaults = NSUserDefaults.standardUserDefaults()
    
    if let doc = defaults.valueForKey(currentId){
        print(doc.description) // Some String Value
        return doc as! String
    }
    else{
        return ""
    }
    
}