//
//  AppDelegate.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/12/15.
//  Copyright © 2015 Meditor. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    // Elements
    var window: NSWindow!
    var newButton: MeditorButton!
    var infoField: InfoTextField!
    var publishButton: MeditorButton!
    var scrollView: NSScrollView!
    var meditorTextView: MeditorTextView!
    var toolbar:NSToolbar!
    var toolbarTabsIdentifierArray:[String] = []
    
    // Position constants
    var textWidth: CGFloat = 700.0;
    var minTextHeight: CGFloat = 500.0;
    var minInsetHeight: CGFloat = 50.0;
    var progressHeight: CGFloat = 2.0;
    
    override init() {
        super.init()
        initElements()
    }
    
    func initElements() {
        
        // Window
        let screenSize = screenResolution()
        window = NSWindow(contentRect: NSMakeRect(100, 100, screenSize.width - 200, screenSize.height - 200), styleMask: NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask | NSMiniaturizableWindowMask, backing: NSBackingStoreType.Buffered, `defer`: false)
        window.minSize = NSMakeSize(textWidth + 100.0, minTextHeight)
        window.opaque = false;
        window.backgroundColor = NSColor.whiteColor();
        window.titleVisibility = NSWindowTitleVisibility.Hidden
        window.movableByWindowBackground = true
        window.delegate = self
        
        // New Button
        newButton = MeditorButton(frame: NSRect(x:0, y:0, width: 40, height: 35), app: self)
        newButton.image = NSImage(named: NSImageNameAddTemplate)
        newButton.toolTip = "Clear workspace and Start over"
        newButton.setButtonType(NSButtonType.MomentaryLightButton)
        newButton.bezelStyle = NSBezelStyle.TexturedRoundedBezelStyle
        newButton.target = self
        newButton.action = Selector("newClicked:")
        
        // Info Field
        infoField = InfoTextField(frame: NSRect(x:0, y:0, width: 500, height: 25))
        infoField.bezelStyle = NSTextFieldBezelStyle.RoundedBezel
        infoField.editable = false
        infoField.textColor = NSColor.blackColor()
        infoField.font = NSFont(name: infoField.font!.familyName!, size: 11)
        
        // Publish Button
        publishButton = MeditorButton(frame: NSRect(x:0, y:0, width: 40, height: 35), app: self)
        publishButton.image = NSImage(named: NSImageNameShareTemplate)
        publishButton.toolTip = "Publish as Draft and Open the draft in medium.com"
        publishButton.setButtonType(NSButtonType.MomentaryLightButton)
        publishButton.bezelStyle = NSBezelStyle.TexturedRoundedBezelStyle
        publishButton.target = self
        publishButton.action = Selector("publishClicked:")
        
        
        // Scroll View
        scrollView = NSScrollView()
        scrollView.borderType = NSBorderType.NoBorder
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autoresizingMask = NSAutoresizingMaskOptions(rawValue: NSAutoresizingMaskOptions.ViewWidthSizable.rawValue | NSAutoresizingMaskOptions.ViewHeightSizable.rawValue)
        window.contentView?.addSubview(scrollView)
        
        // Text View
        meditorTextView = MeditorTextView()
        meditorTextView.verticallyResizable = true
        meditorTextView.horizontallyResizable = false
        meditorTextView.textContainer!.widthTracksTextView = true
        meditorTextView.autoresizingMask = NSAutoresizingMaskOptions(rawValue: NSAutoresizingMaskOptions.ViewWidthSizable.rawValue | NSAutoresizingMaskOptions.ViewHeightSizable.rawValue)
        meditorTextView.delegate = meditorTextView
        meditorTextView.setup(self)
        scrollView.documentView = meditorTextView
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {

        // Positioning
        let frame = (window.contentView?.frame)!
        scrollView.frame.size = NSSize(width: frame.size.width, height: frame.size.height)
        meditorTextView.frame.size = NSSize(width: frame.size.width, height: frame.size.height)
        reposition()
        
        // Toolbar
        toolbarTabsIdentifierArray =  [NSToolbarFlexibleSpaceItemIdentifier, "NewIdentifier", "InfoBarIdentifier", "PublishButtonIdentifier", NSToolbarFlexibleSpaceItemIdentifier]
        toolbar = NSToolbar(identifier:"MeditorToolbarIdentifier")
        toolbar.allowsUserCustomization = true
        toolbar.delegate = self
        window.toolbar = toolbar
        window.makeKeyAndOrderFront(nil);
        window.makeFirstResponder(meditorTextView)
    }
    
    func reposition() {
        meditorTextView.textContainerInset = NSSize(width: (scrollView.contentSize.width - textWidth) / 2, height: minInsetHeight)
    }
    
    func windowDidResize(notification: NSNotification) {
        reposition()
    }
    
    func windowDidEnterFullScreen(notification: NSNotification) {
        reposition()
    }
    
    func windowDidExitFullScreen(notification: NSNotification) {
        reposition()
    }
    
    func windowDidMove(notification: NSNotification) {
        reposition()
    }
    
    
    func screenResolution() -> NSSize {
        var screenRect = NSSize()
        let screenArray = NSScreen.screens()
        for screen in screenArray! {
            screenRect = screen.visibleFrame.size
        }
        return screenRect
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

} 

extension AppDelegate:NSToolbarDelegate {

    func toolbar(toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: String, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem?
    {
        
        if (itemIdentifier == "NewIdentifier") {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.view = newButton
            return toolbarItem
        } else if (itemIdentifier == "InfoBarIdentifier") {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.view = infoField
            return toolbarItem
        } else if(itemIdentifier == "PublishButtonIdentifier") {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.view = publishButton
            return toolbarItem
        } else {
            return nil;
        }

    }
    
    @IBAction func newClicked(sender: NSButton){
        meditorTextView.string = ""
        meditorTextView.textChanged()
        meditorTextView.meditorDoc = MeditorDoc()
        updateFileList(meditorTextView.meditorDoc.id, title: meditorTextView.getTitle())

        if(meditorTextView.isEmpty) {
            return
        } else {
            if(dialogOKCancel("Clear workspace and Start over", text: "Are you sure you want to clear the contents. It is not reversible")) {
                meditorTextView.string = ""
                meditorTextView.textChanged()
            }
        }
    }
    
    func dialogOKCancel(question: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.InformationalAlertStyle
        myPopup.addButtonWithTitle("OK")
        myPopup.addButtonWithTitle("Cancel")
        let res = myPopup.runModal()
        if res == NSAlertFirstButtonReturn {
            return true
        }
        return false
    }
    
    @IBAction func publishClicked(sender: NSButton){
        
        infoField.showProgress("Publishing Draft to medium.com", progressValue: 0.5)
        setUserId("Shiva")
        setAuthId("11b2c0dd55970d2b3987d03a2ca75a6df");
        RestAPIManger.sharedInstance.getUserDetails()
        getName()
        getUserName()
        getProfileUrl()
        getImageUrl()
        
        let authorId = getAuthorId()
        let title = meditorTextView.getTitle()
        let content = prepareContent(meditorTextView.string!)
        let tags:[String] = []
        let contentFormat = "markdown"
        let publishStat = "draft"
        let params:NSDictionary = RestAPIManger.sharedInstance.constructParams(title,contentFormat:contentFormat ,content:content, tags:tags,  publishStatus:publishStat)
        
        
        
        RestAPIManger.sharedInstance.publishDraft(authorId,params: params, app: self)
    }
    
    func postPublish(lastPost : NSDictionary) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: (lastPost["data"]?["url"] as? String)!)!)
        infoField.showProgress("Published Draft to medium.com", progressValue: 0)
    }

    func prepareContent(text: String) -> String {
        return text.stringByReplacingOccurrencesOfString("\n", withString: "\n\n")
    }

    
    func toolbarDefaultItemIdentifiers(toolbar: NSToolbar) -> [String]
    {
        return self.toolbarTabsIdentifierArray;
    }
    
    func toolbarAllowedItemIdentifiers(toolbar: NSToolbar) -> [String]
    {
        return self.toolbarDefaultItemIdentifiers(toolbar)
    }
    
    func toolbarSelectableItemIdentifiers(toolbar: NSToolbar) -> [String]
    {
        return self.toolbarDefaultItemIdentifiers(toolbar)
    }
}