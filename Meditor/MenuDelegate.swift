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
            "Apple": [
                NSMenuItem(title: "Quit",  action: "terminate:", keyEquivalent:"q"),
            ],
            "Edit": [
                NSMenuItem(title: "Copy",  action: "copy:", keyEquivalent:"c"),
            ],
        ]

        for (title, items) in tree {
            let menu = NSMenu(title: title)
            if let item = addItemWithTitle(title, action: nil, keyEquivalent:"") {
                setSubmenu(menu, forItem: item)
                for item in items {
                    menu.addItem(item)
                }
            }
        }
    }
}
