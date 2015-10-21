//
//  AppDelegate.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/9/15.
//  Copyright © 2015 Sivaprakash Ragavan. All rights reserved.
//

import Cocoa

//@NSApplicationMain
class AppDelegate1: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    
        print("starting....")
        //setUserAsAnusha
        setUserId("Anusha")
        //setting the AuthId of the user
        
        setAuthId("19a29e1af6bfa77dfa64f5535bfef29f6");
        
        // get and set UserDetails
        RestAPIManger.sharedInstance.getUserDetails()
        getName()
        getUserName()
        getProfileUrl()
        getImageUrl()
        
        
        let authorId = getAuthorId()
        let title = "Meditor Test 5"
        let content = "# Meditor Test 4  \n\n -This is a test"
        let tags:[String] = ["test", "editor", "siv"]
        let contentFormat = "markdown"
        let publishStat = "draft"
        let params:NSDictionary = RestAPIManger.sharedInstance.constructParams(title,contentFormat:contentFormat ,content:content, tags:tags,  publishStatus:publishStat)
        
        
        RestAPIManger.sharedInstance.publishDraft(authorId,params: params, app: nil)
        
    }
    
    
    
   

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}

