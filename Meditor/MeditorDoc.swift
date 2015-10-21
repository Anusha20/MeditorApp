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
    var id : String
        
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
    
    init(id:String) {
        
        
        // get URL to the the documents directory in the sandbox
        let documentsUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
        
        // add a filename
        let fileUrl = documentsUrl.URLByAppendingPathComponent(id+".md")
        
        let myText = try! String(contentsOfURL: fileUrl, encoding: NSUTF8StringEncoding)
        print(myText)
        
        self.id = id
        self.title = String()
       // self.title = fileList[id] as! String
        self.body = myText
        
    }
    
    init(title: String, body: String,id:String) {
        self.title = title
        self.body = body
        self.id = id
    }
    
    func persist(){
       
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            setCurrentMeditorDocId(self.id)
            
            // get URL to the the documents directory in the sandbox
            let documentsUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
            // add a filename
            let fileUrl = documentsUrl.URLByAppendingPathComponent(self.id+".md")
            print("writing ....."+fileUrl.description)
            
            // write to it
            try! self.title.writeToURL(fileUrl, atomically: true, encoding: NSUTF8StringEncoding)
            try! self.body.writeToURL(fileUrl, atomically: true, encoding: NSUTF8StringEncoding)
            
            print("writing to persist"+fileUrl.description)
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
            }
        }
        
    }
    
    
}

    

