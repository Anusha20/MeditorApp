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

class Story: NSObject {

    var body: String
    var id : String
    
    let titleLength = 40
        
    override init() {
        self.body = String()
        self.id = NSUUID().UUIDString
    }
    
    init(id: String) {
        self.id = id

        let documentsUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
        let fileUrl = documentsUrl.URLByAppendingPathComponent(id + ".md")
        self.body = try! String(contentsOfURL: fileUrl, encoding: NSUTF8StringEncoding)
    }
 
    func save(){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let documentsUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
            let fileUrl = documentsUrl.URLByAppendingPathComponent(self.id+".md")
            try! self.body.writeToURL(fileUrl, atomically: true, encoding: NSUTF8StringEncoding)
            
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
            }
        }
    }
    
    func getSummary() -> [String:AnyObject] {
        return ["id": id, "summary": shorten(body, count: 100)]
    }
    
    func getTitle() -> String {
        var title : String
        if(isEmpty()) {
            return "Untitled"
        } else {
            if((body.rangeOfString("\n")) != nil) {
                title = (body.substringToIndex((body.rangeOfString("\n")?.startIndex)!))
            } else {
                title = body
            }
        }
        return title.stringByReplacingOccurrencesOfString("# ", withString: "")
    }
    
    func wordCount() -> Int {
        return (body.componentsSeparatedByString(" ").count)
    }
    
    func isEmpty() -> Bool {
        return body.isEmpty
    }
    
    //Uitls
    
    func shorten(text : String, count : Int) -> String {
        if(text.characters.count <= count) {
            return text
        } else {
            return text.substringToIndex(text.startIndex.advancedBy(count)) + "..."
        }
    }

    func minsCount(wordCount : Int) -> Int {
        return Int(round(Double(wordCount) / 220.0))
    }
}

    

