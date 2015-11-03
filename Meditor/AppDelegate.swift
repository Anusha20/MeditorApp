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
    var tableView: StoryTableView!
    var scrollView: NSScrollView!
    var tableScrollView: NSScrollView!
    var exportedStoryView: ExportedStoryView!
    var titleTextView: NSTextView!
    var copyButton: NSButton!
    var meditorTextView: MeditorTextView!
    var storyView : NSView!
    var toolbar:NSToolbar!
    var toolbarTabsIdentifierArray:[String] = []
    
    
    var popOverController:PopOverController!
    
    // Position constants
    var minTableWidth: CGFloat = 215.0;
    var minTextWidth: CGFloat = 700.0;
    var minTextHeight: CGFloat = 500.0;
    var minInsetHeight: CGFloat = 50.0;
    var minInsetWidth: CGFloat = 50.0;
    var currentInsetWidth : CGFloat = 0.0;
    var progressHeight: CGFloat = 2.0;
    var titleHeight: CGFloat = 38.0;
    
    var storyListSize : CGFloat = 0.0;
    var storySummaryHeight : CGFloat = 79.0;
    var storyHeaderHeight : CGFloat = 25.0;
    
    var exportedBarHeight : CGFloat = 65.0;
    
    override init() {
        super.init()
        initElements()
       // NSUserDefaults.standardUserDefaults().removeObjectForKey(defaultsKeys.authId+getUserId())
        //23b9116bf40190c4815819f6a56184211c8ba2940a9d7fb22bd6a7c05048e35ce
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
        tableView = StoryTableView(frame: tableScrollView.frame)
        tableView.setDelegate(self)
        tableView.setDataSource(self)
        tableView.addTableColumn(NSTableColumn(identifier: "col1"))
        tableView.headerView = nil
        //tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyle.SourceList
        tableView.intercellSpacing = NSMakeSize(0, 0)
        tableScrollView.documentView = tableView
        
        // Story View
        storyView = NSView()
        storyView.autoresizingMask = NSAutoresizingMaskOptions(rawValue: NSAutoresizingMaskOptions.ViewWidthSizable.rawValue | NSAutoresizingMaskOptions.ViewHeightSizable.rawValue)
        splitView.addSubview(storyView)
        
        // Exported Story View
        exportedStoryView = ExportedStoryView(frame: storyView.frame)
        exportedStoryView.autoresizingMask = NSAutoresizingMaskOptions(rawValue: NSAutoresizingMaskOptions.ViewWidthSizable.rawValue)
        storyView.addSubview(exportedStoryView)
        
        // Scroll View
        scrollView = NSScrollView()
        scrollView.borderType = NSBorderType.NoBorder
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autoresizingMask = NSAutoresizingMaskOptions(rawValue: NSAutoresizingMaskOptions.ViewWidthSizable.rawValue | NSAutoresizingMaskOptions.ViewHeightSizable.rawValue)
        storyView.addSubview(scrollView)
        
        // Text View
        meditorTextView = MeditorTextView(frame: scrollView.frame)
        meditorTextView.verticallyResizable = true
        meditorTextView.horizontallyResizable = false
        meditorTextView.textContainer!.widthTracksTextView = true
        meditorTextView.autoresizingMask = NSAutoresizingMaskOptions(rawValue: NSAutoresizingMaskOptions.ViewWidthSizable.rawValue | NSAutoresizingMaskOptions.ViewHeightSizable.rawValue)
        meditorTextView.allowsUndo = true
        meditorTextView.delegate = meditorTextView
        scrollView.documentView = meditorTextView
        
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        // Positioning
        let frame = (window.contentView?.frame)!
        splitView.frame.size = NSSize(width: frame.width, height: frame.height - titleHeight)
        tableScrollView.frame.size = NSSize(width: minTableWidth, height: splitView.frame.size.height)
        storyView.frame.origin.x = minTableWidth
        storyView.frame.size = NSSize(width: splitView.frame.size.width - minTableWidth, height: splitView.frame.size.height)
        
        if let story = Stories.sharedInstance.getStory(tableView.selectedRow) {
            if(story.isExported()) {
                scrollView.frame.size.height = storyView.frame.size.height - exportedBarHeight
                exportedStoryView.frame.origin.y = storyView.frame.size.height - exportedBarHeight
                exportedStoryView.frame.size.height = exportedBarHeight
            } else {
                scrollView.frame.size.height = storyView.frame.size.height
                exportedStoryView.frame.size.height = 0
            }
        }
        
        titleTextView = NSTextView(frame : NSRect(x: currentInsetWidth, y: exportedStoryView.frame.size.height - 50, width: 540, height: 25))
        titleTextView.backgroundColor = NSColor.clearColor()
        titleTextView.editable = false
        titleTextView.linkTextAttributes = [
            NSForegroundColorAttributeName : NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5),
            NSCursorAttributeName: NSCursor.pointingHandCursor(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
        ]
        exportedStoryView.addSubview(titleTextView)
        
        copyButton = NSButton(frame: NSRect(x: currentInsetWidth + 595, y: exportedStoryView.frame.size.height - 50, width: 100, height: 30))
        copyButton.title = "Make a Copy"
        copyButton.setButtonType(NSButtonType.MomentaryLightButton)
        copyButton.bezelStyle = NSBezelStyle.RegularSquareBezelStyle
        copyButton.target = self
        copyButton.action = Selector("copyClicked:")
        exportedStoryView.addSubview(copyButton)
        
        if let story = Stories.sharedInstance.getStory(Stories.sharedInstance.getCurrentStory()) {
            meditorTextView.setup(self, story: story)
            setExportedView(story)
            tableView.selectRowIndexes(NSIndexSet(index: Stories.sharedInstance.getCurrentStory()), byExtendingSelection: false)
        }

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
        currentInsetWidth = (scrollView.contentSize.width - minTextWidth) / 2
        meditorTextView.textContainerInset = NSSize(width: currentInsetWidth, height: minInsetHeight)
        if(titleTextView != nil) {
            titleTextView.frame.origin.x = currentInsetWidth
            //mediumButton.frame.origin.x = currentInsetWidth + 540
            copyButton.frame.origin.x = currentInsetWidth + 595
        }
        exportedStoryView.frame.origin.y = storyView.frame.size.height - exportedBarHeight
        exportedStoryView.frame.size.height = exportedBarHeight
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
    
    func setExportedView(story: Story) {
        
        if(titleTextView != nil && story.mediumURL != nil) {
            let myAttributedstring = NSMutableAttributedString(string: "Exported to medium.com",
                attributes: [
                    NSFontAttributeName : NSFont(name: "HelveticaNeue", size: 15)!,
                    NSLinkAttributeName : NSURL(string: story.mediumURL)!,
                ]
            )
            titleTextView.textStorage?.setAttributedString(myAttributedstring)
        }
    }
    
    func about(sender: NSMenuItem) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "http://meditorapp.com")!)
    }
    

    func newDocument(sender: NSMenuItem) {
        createNew()
    }

    func copyDocument(sender: NSMenuItem) {
        clone()
    }
    
    func exportDocument(sender: NSMenuItem) {
        publish()
    }

    func collapseList(sender: NSMenuItem) {
        collapse()
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
            var cellView = tableView.makeViewWithIdentifier("headerView", owner: self)
            if(cellView == nil) {
                cellView = NSTableCellView(frame: NSRect(x: 0, y: 0, width: tableView.frame.width, height: storyHeaderHeight))
                cellView!.autoresizingMask = NSAutoresizingMaskOptions(rawValue: NSAutoresizingMaskOptions.ViewWidthSizable.rawValue)
                cellView?.identifier = "headerView"
                
                let storyHeader = NSTextField(frame: NSRect(x: 10, y: 4, width: cellView!.frame.width - 20, height: cellView!.frame.height - 8))
                storyHeader.autoresizingMask = NSAutoresizingMaskOptions(rawValue: NSAutoresizingMaskOptions.ViewWidthSizable.rawValue)
                storyHeader.editable = false
                storyHeader.selectable = false
                storyHeader.drawsBackground = false
                storyHeader.bordered = false
                cellView?.addSubview(storyHeader)
            }
            
            (cellView?.subviews[0] as! NSTextField).attributedStringValue = Stories.sharedInstance.getAttributedSummary(row)
            return cellView
        } else {
            var cellView = tableView.makeViewWithIdentifier("summaryView", owner: self)
            if(cellView == nil) {
                cellView = NSTableCellView(frame: NSRect(x: 0, y: 0, width: tableView.frame.width, height: storySummaryHeight))
                cellView!.autoresizingMask = NSAutoresizingMaskOptions(rawValue: NSAutoresizingMaskOptions.ViewWidthSizable.rawValue)
                cellView?.identifier = "summaryView"
                
                let storySummary = NSTextField(frame: NSRect(x: 10, y: 6, width: cellView!.frame.width - 20, height: cellView!.frame.height - 12))
                storySummary.autoresizingMask = NSAutoresizingMaskOptions(rawValue: NSAutoresizingMaskOptions.ViewWidthSizable.rawValue)
                storySummary.editable = false
                storySummary.selectable = false
                storySummary.drawsBackground = false
                storySummary.bordered = false
                cellView?.addSubview(storySummary)

                let bottomBorder = NSView()
                bottomBorder.frame = CGRectMake(10, 0, cellView!.frame.size.width - 20, 0.3);
                bottomBorder.autoresizingMask = NSAutoresizingMaskOptions(rawValue: NSAutoresizingMaskOptions.ViewWidthSizable.rawValue)
                bottomBorder.wantsLayer = true
                bottomBorder.layer = CALayer()
                bottomBorder.layer!.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor
                cellView?.addSubview(bottomBorder)
            }
            
            (cellView?.subviews[0] as! NSTextField).attributedStringValue = Stories.sharedInstance.getAttributedSummary(row)
            return cellView
        }
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        Stories.sharedInstance.setCurrentStory(tableView.selectedRow)
        if let story = Stories.sharedInstance.getStory(tableView.selectedRow) {
            if(story.isExported()) {
                scrollView.frame.size.height = storyView.frame.size.height - exportedBarHeight
            } else {
                scrollView.frame.size.height = storyView.frame.size.height
            }
            meditorTextView.story = story
            meditorTextView.storyChanged()
            setExportedView(story)
        } else {
            tableView.selectRowIndexes(NSIndexSet(index: Stories.sharedInstance.getCurrentStory()), byExtendingSelection: false)
        }
        tableView.scrollRowToVisible(Stories.sharedInstance.getCurrentStory())
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
    

    func newClicked(sender: NSButton){
        createNew()
    }

    func copyClicked(sender: NSButton) {
        clone()
    }
    
    func publishClicked(sender: NSButton){
        publish()
    }
    
    func collapseClicked(sender: NSButton){
        collapse()
    }

    func createNew(){
        let newStory = Story()
        newStory.save()
        Stories.sharedInstance.addStory(newStory)
        tableView.reloadData()
        tableView.selectRowIndexes(NSIndexSet(index: Stories.sharedInstance.getCurrentStory()), byExtendingSelection: false)
        window.makeFirstResponder(meditorTextView)
    }

    func clone() {
        let newStory = Story()
        newStory.body = Stories.sharedInstance.getStory(Stories.sharedInstance.getCurrentStory())!.body
        newStory.save()
        Stories.sharedInstance.addStory(newStory)
        tableView.reloadData()
        tableView.selectRowIndexes(NSIndexSet(index: Stories.sharedInstance.getCurrentStory()), byExtendingSelection: false)
        window.makeFirstResponder(meditorTextView)
    }

//    func dialogOKCancel(question: String, text: String) -> Bool {
//        let myPopup: NSAlert = NSAlert()
//        myPopup.messageText = question
//        myPopup.informativeText = text
//        myPopup.alertStyle = NSAlertStyle.InformationalAlertStyle
//        myPopup.addButtonWithTitle("OK")
//        myPopup.addButtonWithTitle("Cancel")
//        let res = myPopup.runModal()
//        if res == NSAlertFirstButtonReturn {
//            return true
//        }
//        return false
//    }
    
    func callPublishAPI(){
        if(!getAuthId().isEmpty && !getAuthorId().isEmpty){
            infoField.showProgress("Exporting to medium.com", progressValue: 0.5)
            /* setUserId("Shiva")
            setAuthId("11b2c0dd55970d2b3987d03a2ca75a6df");*/
            
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
    
    func publish() {
        if(getAuthId().isEmpty){
            popOverController.showPopover(publishButton)
        }else{
            callPublishAPI()
        }
    }
    
    func onPublishFailure(){
        self.infoField.textColor = NSColor(calibratedRed: 1.0, green: 0.0, blue: 0.0, alpha: 0.7)
        self.infoField.showProgress("Failure exporting to medium.com", progressValue: 0)
        
    }
    func postPublish(lastPost : NSDictionary) {
        dispatch_async(dispatch_get_main_queue()) {
            let mediumURL = (lastPost["data"]?["url"] as? String)!
            NSWorkspace.sharedWorkspace().openURL(NSURL(string: mediumURL)!)
            self.infoField.showProgress("Exported to medium.com", progressValue: 0)
            Stories.sharedInstance.markCurrentPublished(mediumURL)
            self.tableView.reloadData()
            self.tableView.selectRowIndexes(NSIndexSet(index: Stories.sharedInstance.getCurrentStory()), byExtendingSelection: false)
            self.window.makeFirstResponder(self.meditorTextView)
        }
    }
    
    func prepareContent(text: String) -> String {
        return text.stringByReplacingOccurrencesOfString("\n", withString: "\n\n")
    }
    
    func collapse() {
        if(isStoryListCollapsed()) {
            splitView.setPosition(storyListSize, ofDividerAtIndex: 0)
        } else {
            splitView.setPosition(0.0, ofDividerAtIndex: 0)
        }
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