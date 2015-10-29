//
//  ExportedStoryView.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/28/15.
//  Copyright © 2015 Meditor. All rights reserved.
//

import Cocoa

class ExportedStoryView: NSView {

    let bgColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.03)

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        bgColor.setFill()
        NSRectFill(dirtyRect);
    }
    
}
