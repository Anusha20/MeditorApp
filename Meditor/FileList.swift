//
//  FileList.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/20/15.
//  Copyright © 2015 Meditor. All rights reserved.
//

import Foundation


let keyFileList = "fileList"

var fileList : NSDictionary = NSDictionary()

func setFileList(jo: NSDictionary){
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
    fileList = userDefaults.valueForKey(keyFileList)
   
}

func getFileList() -> NSDictionary{
    if(fileList == {})
}