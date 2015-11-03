//
//  MenuDelegate.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/17/15.
//  Copyright © 2015 Meditor. All rights reserved.
//

import Cocoa

class MenuDelegate: NSMenu {

    override init(title aTitle: String) {
        super.init(title: aTitle)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let tree = [
            "Meditor": [
                NSMenuItem(title: "About Meditor",  action: "orderFrontStandardAboutPanel:", keyEquivalent:""),
                NSMenuItem.separatorItem(),
                NSMenuItem(title: "Quit Meditor",  action: "terminate:", keyEquivalent:"q"),
            ],
            "File": [
                NSMenuItem(title: "New Story",  action: "newDocument:", keyEquivalent:"n"),
                NSMenuItem(title: "Make a copy",  action: "copyDocument:", keyEquivalent:"N"),
                NSMenuItem.separatorItem(),
                NSMenuItem(title: "Export to medium.com",  action: "exportDocument:", keyEquivalent:"M"),
            ],
            "Edit": [
                NSMenuItem(title: "Undo",  action: "undo:", keyEquivalent:"z"),
                NSMenuItem(title: "Redo",  action: "redo:", keyEquivalent:"Z"),
                NSMenuItem.separatorItem(),
                NSMenuItem(title: "Cut",  action: "cut:", keyEquivalent:"x"),
                NSMenuItem(title: "Copy",  action: "copy:", keyEquivalent:"c"),
                NSMenuItem(title: "Paste",  action: "pasteAsPlainText:", keyEquivalent:"v"),
                NSMenuItem(title: "Select All",  action: "selectAll:", keyEquivalent:"a"),
            ],
            "View": [
                NSMenuItem(title: "Toggle Story List",  action: "collapseList:", keyEquivalent:"s"),
                NSMenuItem.separatorItem(),
            ],
            "Window": [
                NSMenuItem(title: "Minimize",  action: "performMiniaturize:", keyEquivalent:"m"),
                NSMenuItem(title: "Zoom",  action: "performZoom:", keyEquivalent:""),
                NSMenuItem.separatorItem(),
                NSMenuItem(title: "Bring All to Front",  action: "arrangeInFront:", keyEquivalent:""),
            ],
            "Help": [
                NSMenuItem(title: "Meditor Help",  action: "about:", keyEquivalent:"?"),
            ],
        ]

        addMenu("Meditor", items: tree["Meditor"]!)
        addMenu("File", items: tree["File"]!)
        addMenu("Edit", items: tree["Edit"]!)
        addMenu("View", items: tree["View"]!)
        addMenu("Window", items: tree["Window"]!)
        addMenu("Help", items: tree["Help"]!)
        
    }
    
    func addMenu(title: String, items: [NSMenuItem]) {
        let menu = NSMenu(title: title)
        if let item = addItemWithTitle(title, action: nil, keyEquivalent:"") {
            setSubmenu(menu, forItem: item)
            for item in items {
                menu.addItem(item)
            }
        }
    }
}
