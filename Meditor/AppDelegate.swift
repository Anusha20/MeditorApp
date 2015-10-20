//
//  AppDelegate.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/12/15.
//  Copyright © 2015 Meditor. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    var window: NSWindow!

    var scrollView: NSScrollView!
    var meditorTextView: MeditorTextView!
    var toolbar:NSToolbar!
    var toolbarTabsIdentifierArray:[String] = []
    
    var textWidth: CGFloat = 700.0;
    var minTextHeight: CGFloat = 500.0;
    var minInsetHeight: CGFloat = 50.0;
    
    let controller: NSWindowController
    
    override init() {

        controller = NSWindowController(window: window)
        super.init()
        
        // Window
        let screenSize = screenResolution()
        window = NSWindow(contentRect: NSMakeRect(100, 100, screenSize.width - 200, screenSize.height - 200), styleMask: NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask | NSMiniaturizableWindowMask, backing: NSBackingStoreType.Buffered, `defer`: false)
        window.minSize = NSMakeSize(textWidth + 100.0, minTextHeight)
        window.opaque = false;
        window.backgroundColor = NSColor.whiteColor();
        window.titleVisibility = NSWindowTitleVisibility.Hidden
        window.movableByWindowBackground = true
        window.delegate = self
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {

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
        meditorTextView.setup()
        scrollView.documentView = meditorTextView

        // Positioning
        let frame = (window.contentView?.frame)!
        scrollView.frame.size = NSSize(width: frame.size.width, height: frame.size.height)
        meditorTextView.frame.size = NSSize(width: frame.size.width, height: frame.size.height)
        reposition()
        
        // Toolbar
        toolbarTabsIdentifierArray =  [NSToolbarFlexibleSpaceItemIdentifier, "PublishButtonIdentifier"]
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
        
        if(itemIdentifier == "PublishButtonIdentifier") {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.toolTip = "Publishes the article as Draft and opens the article in Medium"
            
            let publishButton = NSButton(frame: NSRect(x:0, y:0, width: 200, height: 35))
            //publishButton.image = NSImage(named: "CloudWI")
            publishButton.title = "Open in Medium.com"
            publishButton.setButtonType(NSButtonType.MomentaryLightButton)
            publishButton.bezelStyle = NSBezelStyle.RoundedBezelStyle
            publishButton.target = self
            publishButton.action = Selector("publishClicked:")

            toolbarItem.view = publishButton

            //        toolbarItem.setMinSize(NSMakeSize(100,NSHeight(searchFieldOutlet.frame)));
            //        toolbarItem.setMaxSize(NSMakeSize(400,NSHeight(searchFieldOutlet.frame)));
            //
            //        // Create the custom menu
            //        NSMenu *submenu=[[[NSMenu alloc] init] autorelease];
            //        NSMenuItem *submenuItem=[[[NSMenuItem alloc] initWithTitle: @"Search Panel"
            //        action:@selector(searchUsingSearchPanel:)
            //        keyEquivalent: @""] autorelease];
            //        NSMenuItem *menuFormRep=[[[NSMenuItem alloc] init] autorelease];
            //
            //        [submenu addItem: submenuItem];
            //        [submenuItem setTarget:self];
            //        [menuFormRep setSubmenu:submenu];
            //        [menuFormRep setTitle:[toolbarItem label]];
            //        [toolbarItem setMenuFormRepresentation:menuFormRep];
        
            return toolbarItem
        }
        else {
            return nil;
        }

    }
    
    @IBAction func publishClicked(sender: NSButton){
        NSLog("Publish Clicked");
        
        setUserId("Shiva")
        setAuthId("11b2c0dd55970d2b3987d03a2ca75a6df");
        
        RestAPIManger.sharedInstance.getUserDetails()
        getName()
        getUserName()
        getProfileUrl()
        getImageUrl()
        
        let authorId = getAuthorId()
        let title = prepareTitle(meditorTextView.string!)
        let content = prepareContent(meditorTextView.string!)
        let tags:[String] = []
        let contentFormat = "markdown"
        let publishStat = "draft"
        let params:NSDictionary = RestAPIManger.sharedInstance.constructParams(title,contentFormat:contentFormat ,content:content, tags:tags,  publishStatus:publishStat)
        
        RestAPIManger.sharedInstance.publishDraft(authorId,params: params)
    }
    
    func prepareTitle(text: String) -> String {
        return text.stringByReplacingOccurrencesOfString("# ", withString: "")
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