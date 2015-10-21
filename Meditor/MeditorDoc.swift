//
//  MeditorDoc.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/12/15.
//  Copyright © 2015 Meditor. All rights reserved.
//

import Foundation
import AppKit
import Cocoa

class MeditorDoc: NSObject {

    var title: String
    var body: String
    let id : String
        
    override init() {
        self.title = String()
        self.body = String()
        self.id = NSUUID().UUIDString
    }
        
    init(title: String, body: String) {
        self.title = title
        self.body = body
        self.id = NSUUID().UUIDString
    }
    
    func persist(){
       
       
        
        // get URL to the the documents directory in the sandbox
        let documentsUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
        
        // add a filename
        let fileUrl = documentsUrl.URLByAppendingPathComponent(id+".md")
         print("writing ....."+fileUrl.description)
        
        // write to it
        try! title.writeToURL(fileUrl, atomically: true, encoding: NSUTF8StringEncoding)
        try! body.writeToURL(fileUrl, atomically: true, encoding: NSUTF8StringEncoding)
        
        print("writing to persist"+fileUrl.description)
    }
    
    func load(title:String){
        
        
        // get URL to the the documents directory in the sandbox
        let documentsUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
        
        // add a filename
        let fileUrl = documentsUrl.URLByAppendingPathComponent(id+".md")
        
        let myText = try! String(contentsOfURL: fileUrl, encoding: NSUTF8StringEncoding)
        print(myText)
        
    }
    
}
