//
//  StoryTableView.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/31/15.
//  Copyright © 2015 Meditor. All rights reserved.
//

import Cocoa

class StoryTableView: NSTableView {

    
    // Ref : https://gist.github.com/cobbal/303491c7c87d2ed3364e
    
    override func keyDown(theEvent: NSEvent) {
        
        func intToString(x : Int) -> String {
            return String(UnicodeScalar(x))
        }

        NSLog(theEvent.charactersIgnoringModifiers!)
        
        switch theEvent.charactersIgnoringModifiers! {
            
        case intToString(NSCarriageReturnCharacter) :
            let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window.makeFirstResponder(appDelegate.meditorTextView)
            break
        case intToString(NSRightArrowFunctionKey) :
            let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window.makeFirstResponder(appDelegate.meditorTextView)
            break
        default:
            super.keyDown(theEvent)
        }
        
    }
    
}
