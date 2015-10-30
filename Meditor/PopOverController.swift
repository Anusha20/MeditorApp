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
    
    @IBOutlet weak var errorMsg: NSTextField!
   
    
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
   
    func updateUserDetails(sender: AnyObject){
        RestAPIManger.sharedInstance.getUserDetails(self,sender:sender)
        getName()
        getUserName()
        getProfileUrl()
        getImageUrl()
    }

    func onSuccessFulUpdateUserDetails(sender: AnyObject){
            hideErrorMessage()
            setAuthId(bearerIdTextField.stringValue)
            print("bearer id:"+getAuthId())
            closePopover(sender)
            appDelegate.callPublishAPI()
        
    }
    
    
    
    func showErrorMessage(message:String){
        self.errorMsg.textColor = NSColor(calibratedRed: 1.0, green: 0.0, blue: 0.0, alpha: 0.7)
        self.errorMsg.stringValue = message
        self.errorMsg.hidden = false
        
    }
    func hideErrorMessage(){
        self.errorMsg.stringValue = ""
        errorMsg.hidden = true
        
    }
   
    @IBAction func saveId(sender: AnyObject) {
        hideErrorMessage()
        updateUserDetails(sender)
        
        
        
    }
    @IBAction func cancel(sender: AnyObject) {
        hideErrorMessage()
        closePopover(sender)

    }
    
    
    }