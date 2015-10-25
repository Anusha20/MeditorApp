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
    
    let keyStoryList = "storyList"
    var list:[[String:AnyObject]] = []
    
    override init() {
        if let storyList = userDefaults.arrayForKey(keyStoryList) as? [[String:AnyObject]] {
            if (!storyList.isEmpty) {
                list = storyList
            }
        }
    }
    
    func save() {
        userDefaults.setObject(list, forKey: keyStoryList)
        userDefaults.synchronize()
    }
    
    func addStory(story: Story) {
        list.insert(story.getSummary(), atIndex: 0)
        save()
    }
    
    func updateStory(i: Int, story: Story) {
        list[i] = story.getSummary()
        save()
    }
    
    func getStory(i: Int) -> Story {
        return Story(id: (list[i]["id"] as? String)!)
    }
    
    func getSummary(i: Int) -> String {
        return (list[i]["summary"] as? String)!
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