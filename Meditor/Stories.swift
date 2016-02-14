//
//  FileList.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/20/15.
//  Copyright © 2015 Meditor. All rights reserved.
//

import Foundation
import AppKit
import Cocoa

class Stories: NSObject {
    static let sharedInstance = Stories()
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    let keyDraftList = "draftList"
    let keyExportedList = "exportedList"
    var list:[[String:AnyObject]] = []
    
    var draftListheading = 0;
    var exportedListheading = 1;
    var headingsCount = 2;
    
    override init() {
        super.init()
        
        // Cleaning lists
        //        userDefaults.removeObjectForKey(keyDraftList)
        //        userDefaults.removeObjectForKey(keyExportedList)
        //        userDefaults.removeObjectForKey(keyCurrentStory)
        
        // Adding Headings
        draftListheading = 0;
        list.append(["id": "heading", "summary": "Still Working"])
        if let draftList = userDefaults.arrayForKey(keyDraftList) as? [[String:AnyObject]] {
            list.appendContentsOf(draftList)
        }
        
        exportedListheading = list.count;
        list.append(["id": "heading", "summary": "Archive"])
        if let exportedList = userDefaults.arrayForKey(keyExportedList) as? [[String:AnyObject]] {
            list.appendContentsOf(exportedList)
        }
        
        if(list.count == headingsCount) {
            let newStory = Story()
            newStory.save()
            addStory(newStory)
        }
        
    }
    
    func save() {
        
        var draftList = list
        draftList.removeRange(exportedListheading..<list.count)
        draftList.removeAtIndex(draftListheading)
        userDefaults.setObject(draftList, forKey: keyDraftList)
        
        var exportedList = list
        exportedList.removeRange(0..<(exportedListheading + 1))
        userDefaults.setObject(exportedList, forKey: keyExportedList)
        
        userDefaults.synchronize()
    }
    
    func addStory(story: Story) {
        list.insert(story.getSummary(), atIndex: draftListheading + 1)
        exportedListheading++;
        setCurrentStory(draftListheading + 1)
        save()
    }
    
    func markCurrentPublished(mediumURL: String) {
        let story = getStory(getCurrentStory())
        story?.mediumURL = mediumURL
        exportedListheading--;
        list.removeAtIndex(getCurrentStory())
        list.insert((story?.getSummary())!, atIndex: exportedListheading + 1)
        save()
        setCurrentStory(exportedListheading + 1)
    }
    
    func updateStory(i: Int, story: Story) {
        list[i] = story.getSummary()
        save()
    }
    
    func getStory(i: Int) -> Story? {
        if(i < 0 || i == draftListheading || i == exportedListheading || i >= list.count) {
            return nil
        } else if (i > exportedListheading) {
            return Story(id: (list[i]["id"] as? String)!, mediumURL: (list[i]["mediumURL"] as? String)!)
        } else {
            return Story(id: (list[i]["id"] as? String)!)
        }
    }
    
    func getAttributedSummary(i: Int) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: (list[i]["summary"] as? String)!);
        if let titleLength = list[i]["titleLength"] as? Int {
            attrString.addAttribute(NSFontAttributeName, value: NSFont.boldSystemFontOfSize(NSFont.systemFontSize() - 1), range: NSMakeRange(0, titleLength))
        }
        return attrString
    }
    
    let keyCurrentStory = "currentStoryIndex"
    
    func setCurrentStory(i: Int) {
        userDefaults.setValue(i, forKey: keyCurrentStory)
        userDefaults.synchronize()
    }
    
    func getCurrentStory() -> Int {
        return userDefaults.integerForKey(keyCurrentStory)
    }
    
}