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
    var collapseButton: NSButton!
    var newButton: NSButton!
    var infoField: InfoTextField!
    var publishButton: NSButton!
    var splitView:NSSplitView!
    var tableView: NSTableView!
    var scrollView: NSScrollView!
    var tableScrollView: NSScrollView!
    var meditorTextView: MeditorTextView!
    var toolbar:NSToolbar!
    var toolbarTabsIdentifierArray:[String] = []
     
    
    var popOverController:PopOverController!
    
    // Position constants
    var minTableWidth: CGFloat = 250.0;
    var minTextWidth: CGFloat = 700.0;
    var minTextHeight: CGFloat = 500.0;
    var minInsetHeight: CGFloat = 50.0;
    var minInsetWidth: CGFloat = 50.0;
    var progressHeight: CGFloat = 2.0;
    var titleHeight: CGFloat = 38.0;

    
    var storyListSize : CGFloat = 0.0;
    var storySummaryHeight : CGFloat = 70.0;
    var storyHeaderHeight : CGFloat = 25.0;
    
    override init() {
        super.init()
        initElements()
        NSUserDefaults.standardUserDefaults().removeObjectForKey(defaultsKeys.authId+getUserId())
    }
    
    func initElements() {
        MarkDownFormatter.sharedInstance.setup()
        // Window
        let screenSize = screenResolution()
        window = NSWindow(contentRect: NSMakeRect(100, 100, screenSize.width - 200, screenSize.height - 200), styleMask: NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask | NSMiniaturizableWindowMask | NSFullSizeContentViewWindowMask, backing: NSBackingStoreType.Buffered, `defer`: false)
        window.minSize = NSMakeSize(minTableWidth + minTextWidth + (minInsetWidth * 2), minTextHeight)
        window.opaque = false;
        window.backgroundColor = NSColor.whiteColor();
        window.titleVisibility = NSWindowTitleVisibility.Hidden
        window.movableByWindowBackground = true
        window.delegate = self
        
        // Collapse Button
        collapseButton = NSButton(frame: NSRect(x:0, y:0, width: 40, height: 35))
        collapseButton.image = NSImage(named: NSImageNameListViewTemplate)
        collapseButton.setButtonType(NSButtonType.MomentaryLightButton)
        collapseButton.bezelStyle = NSBezelStyle.TexturedRoundedBezelStyle
        collapseButton.target = self
        collapseButton.action = Selector("collapseClicked:")
        
        // New Button
        newButton = NSButton(frame: NSRect(x:0, y:0, width: 75, height: 35))
        newButton.title = "New Story"
        newButton.setButtonType(NSButtonType.MomentaryLightButton)
        newButton.bezelStyle = NSBezelStyle.TexturedRoundedBezelStyle
        newButton.target = self
        newButton.action = Selector("newClicked:")
        
        // Info Field
        infoField = InfoTextField(frame: NSRect(x:0, y:0, width: 450, height: 25))
        infoField.bezelStyle = NSTextFieldBezelStyle.RoundedBezel
        infoField.editable = false
        infoField.textColor = NSColor.blackColor()
        infoField.font = NSFont(name: infoField.font!.familyName!, size: 11)
        
        // Publish Button
        publishButton = NSButton(frame: NSRect(x:0, y:0, width: 150, height: 35))
        publishButton.title = "Export to medium.com"
        publishButton.setButtonType(NSButtonType.MomentaryLightButton)
        publishButton.bezelStyle = NSBezelStyle.TexturedRoundedBezelStyle
        publishButton.target = self
        publishButton.action = Selector("publishClicked:")
        
        // Split View
        splitView = NSSplitView()
        splitView.dividerStyle = NSSplitViewDividerStyle.Thin
        splitView.vertical = true;
        splitView.delegate = self
        splitView.autoresizingMask = NSAutoresizingMaskOptions(rawValue: NSAutoresizingMaskOptions.ViewWidthSizable.rawValue | NSAutoresizingMaskOptions.ViewHeightSizable.rawValue)
        window.contentView?.addSubview(splitView)
        

       popOverController = PopOverController(nibName: "PopOverController", bundle: nil)
        popOverController.setUp(self)
        
        // Table Scroll View
        tableScrollView = NSScrollView()
        tableScrollView.identifier = "tableScrollView"
        tableScrollView.borderType = NSBorderType.NoBorder
        tableScrollView.hasVerticalScroller = true
        tableScrollView.hasHorizontalScroller = false
        tableScrollView.autoresizingMask = NSAutoresizingMaskOptions(rawValue: NSAutoresizingMaskOptions.ViewWidthSizable.rawValue | NSAutoresizingMaskOptions.ViewHeightSizable.rawValue)
        splitView.addSubview(tableScrollView)
        
        // Table View
        tableView = NSTableView(frame: tableScrollView.frame)
        tableView.setDelegate(self)
        tableView.setDataSource(self)
        tableView.addTableColumn(NSTableColumn(identifier: "col1"))
        tableView.headerView = nil
        tableScrollView.documentView = tableView

        
        // Scroll View
        scrollView = NSScrollView()
        scrollView.borderType = NSBorderType.NoBorder
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autoresizingMask = NSAutoresizingMaskOptions(rawValue: NSAutoresizingMaskOptions.ViewWidthSizable.rawValue | NSAutoresizingMaskOptions.ViewHeightSizable.rawValue)
        splitView.addSubview(scrollView)
        
        // Text View
        meditorTextView = MeditorTextView(frame: scrollView.frame)
        meditorTextView.verticallyResizable = true
        meditorTextView.horizontallyResizable = false
        meditorTextView.textContainer!.widthTracksTextView = true
        meditorTextView.autoresizingMask = NSAutoresizingMaskOptions(rawValue: NSAutoresizingMaskOptions.ViewWidthSizable.rawValue | NSAutoresizingMaskOptions.ViewHeightSizable.rawValue)
        meditorTextView.delegate = meditorTextView
        scrollView.documentView = meditorTextView

        if let story = Stories.sharedInstance.getStory(Stories.sharedInstance.getCurrentStory()) {
            meditorTextView.setup(self, story: story)
            tableView.selectRowIndexes(NSIndexSet(index: Stories.sharedInstance.getCurrentStory()), byExtendingSelection: false)
        }
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        // Positioning
        let frame = (window.contentView?.frame)!
        splitView.frame.size = NSSize(width: frame.width, height: frame.height - titleHeight)
        tableScrollView.frame.size = NSSize(width: minTableWidth, height: splitView.frame.size.height)
        scrollView.frame.origin.x = minTableWidth
        scrollView.frame.size = NSSize(width: splitView.frame.size.width - minTableWidth, height: splitView.frame.size.height)
        
        reposition()
        
        // Toolbar
        toolbarTabsIdentifierArray =  ["CollapseIdentifier", "NewIdentifier", NSToolbarFlexibleSpaceItemIdentifier, "InfoBarIdentifier", NSToolbarFlexibleSpaceItemIdentifier, "PublishButtonIdentifier"]
        toolbar = NSToolbar(identifier:"MeditorToolbarIdentifier")
        toolbar.allowsUserCustomization = true
        toolbar.delegate = self
        window.toolbar = toolbar
        window.makeKeyAndOrderFront(nil);
        window.makeFirstResponder(meditorTextView)
    }
    
    func reposition() {
        meditorTextView.textContainerInset = NSSize(width: (scrollView.contentSize.width - minTextWidth) / 2, height: minInsetHeight)
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

extension AppDelegate: NSSplitViewDelegate {
    
    func splitViewDidResizeSubviews(notification: NSNotification) {
        if(isStoryListCollapsed()) {
            storyListSize = minTableWidth
        } else {
            storyListSize = tableView.frame.size.width
        }
        window.minSize = NSMakeSize(storyListSize + minTextWidth + (minInsetWidth * 2), minTextHeight)
        reposition()
    }
    
    func splitView(splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return self.splitView.frame.width - (minTextWidth + (minInsetWidth * 2))
    }
    
    func splitView(splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return minTableWidth
    }
    
    func splitView(splitView: NSSplitView, shouldAdjustSizeOfSubview view: NSView) -> Bool {
        if(view.identifier == "tableScrollView") {
            return false
        } else {
            return true
        }
    }
    
    func splitView(splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
        if(subview.identifier == "tableScrollView") {
            return true
        } else {
            return false
        }
    }
    
}

extension AppDelegate: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return Stories.sharedInstance.list.count
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if(isHeader(row)) {
            return storyHeaderHeight
        } else {
            return storySummaryHeight
        }
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if(isHeader(row)) {
            let cellView = tableView.makeViewWithIdentifier("headerView", owner: self)
            var storyHeader : NSTextView
            if(cellView == nil) {
                storyHeader = NSTextView()
                storyHeader.frame.size.height = storyHeaderHeight
                storyHeader.editable = false
                storyHeader.backgroundColor = NSColor(CGColor: CGColorCreateGenericRGB(256.0, 256.0, 256.0, 0.1))!
                storyHeader.textContainerInset = NSSize(width: 10.0, height: 5.0)
            } else {
                storyHeader = (cellView as! SummaryTextView)
            }
            
            storyHeader.string = Stories.sharedInstance.getSummary(row)
            return storyHeader
        } else {
            let cellView = tableView.makeViewWithIdentifier("summaryView", owner: self)
            var storySummary : SummaryTextView
            if(cellView == nil) {
                storySummary = SummaryTextView()
                storySummary.setup(self)
                storySummary.frame.size.height = storySummaryHeight
                storySummary.textContainerInset = NSSize(width: 10.0, height: 10.0)
            } else {
                storySummary = (cellView as! SummaryTextView)
            }
            
            storySummary.string = Stories.sharedInstance.getSummary(row)
            return storySummary
        }
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        Stories.sharedInstance.setCurrentStory(tableView.selectedRow)
        if let story = Stories.sharedInstance.getStory(tableView.selectedRow) {
            meditorTextView.story = story
            meditorTextView.storyChanged()
        } else {
            tableView.selectRowIndexes(NSIndexSet(index: Stories.sharedInstance.getCurrentStory()), byExtendingSelection: false)
        }
    }
    
    func tableView(tableView: NSTableView, isGroupRow row: Int) -> Bool {
        return isHeader(row)
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return !isHeader(row)
    }
    
    func isHeader(row: Int) -> Bool {
        if (Stories.sharedInstance.list[row]["id"] as? String == "heading") {
            return true
        }
        return false
    }
}

extension AppDelegate: NSToolbarDelegate {
    
    func toolbar(toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: String, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem?
    {
        if (itemIdentifier == "CollapseIdentifier") {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.view = collapseButton
            return toolbarItem
        } else if (itemIdentifier == "NewIdentifier") {
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
    
    func isStoryListCollapsed() -> Bool {
        return splitView.isSubviewCollapsed(tableScrollView)
    }
    
    func collapseClicked(sender: NSButton){
        if(isStoryListCollapsed()) {
            splitView.setPosition(storyListSize, ofDividerAtIndex: 0)
        } else {
            splitView.setPosition(0.0, ofDividerAtIndex: 0)
        }
    }
    
    func newClicked(sender: NSButton){
        let newStory = Story()
        newStory.save()
        Stories.sharedInstance.addStory(newStory)
        tableView.reloadData()
        tableView.selectRowIndexes(NSIndexSet(index: Stories.sharedInstance.getCurrentStory()), byExtendingSelection: false)
        window.makeFirstResponder(meditorTextView)
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
    

        
   
    
    func callPublishAPI(){
        if(!getAuthId().isEmpty){
        infoField.showProgress("Publishing Draft to medium.com", progressValue: 0.5)
        /* setUserId("Shiva")
        setAuthId("11b2c0dd55970d2b3987d03a2ca75a6df");*/
        RestAPIManger.sharedInstance.getUserDetails()
        getName()
        getUserName()
        getProfileUrl()
        getImageUrl()
        
        let authorId = getAuthorId()
        let title = meditorTextView.story.getTitle()
        let content = prepareContent(meditorTextView.string!)
        let tags:[String] = []
        let contentFormat = "markdown"
        let publishStat = "draft"
        let params:NSDictionary = RestAPIManger.sharedInstance.constructParams(title,contentFormat:contentFormat ,content:content, tags:tags,  publishStatus:publishStat)
        
        RestAPIManger.sharedInstance.publishDraft(authorId,params: params, app: self)
        }
    }
    
    
    @IBAction func publishClicked(sender: NSButton){
        if(getAuthId().isEmpty){
            popOverController.showPopover(sender)
        }else{
            callPublishAPI()
        }
        
     
    }
    
    func postPublish(lastPost : NSDictionary) {
        dispatch_async(dispatch_get_main_queue()) {
            let mediumURL = (lastPost["data"]?["url"] as? String)!
            NSWorkspace.sharedWorkspace().openURL(NSURL(string: mediumURL)!)
            self.infoField.showProgress("Published Draft to medium.com", progressValue: 0)
            Stories.sharedInstance.markCurrentPublished(mediumURL)
            self.tableView.reloadData()
            self.tableView.selectRowIndexes(NSIndexSet(index: Stories.sharedInstance.getCurrentStory()), byExtendingSelection: false)
            self.window.makeFirstResponder(self.meditorTextView)
        }
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