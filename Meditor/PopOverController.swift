//
//  PopOverController.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/25/15.
//  Copyright © 2015 Meditor. All rights reserved.
//

import Cocoa

class PopOverController: NSViewController {

    var popover:NSPopover!
    var appDelegate:AppDelegate!
    
    @IBOutlet weak var bearerIdTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    func setUp(app:AppDelegate){
        popover = NSPopover()
        popover.contentViewController = self
        appDelegate = app
    }

       
    func showPopover(sender: AnyObject?) {
        if let button = sender {
            let pushButton = button as! NSButton
            popover.showRelativeToRect(pushButton.bounds, ofView:pushButton, preferredEdge: NSRectEdge.MinY)
        }
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
}


extension PopOverController {
   
   
    @IBAction func saveId(sender: AnyObject) {
        print("save .....")
        setAuthId(bearerIdTextField.stringValue)
        print("bearer id:"+getAuthId())
        closePopover(sender)
        appDelegate.callPublishAPI()
        
        
    }
    @IBAction func cancel(sender: AnyObject) {
        closePopover(sender)

    }
    
    
    }