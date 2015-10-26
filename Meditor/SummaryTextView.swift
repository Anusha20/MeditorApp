//
//  SummaryTextView.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/24/15.
//  Copyright © 2015 Meditor. All rights reserved.
//

import Cocoa

class SummaryTextView: NSTextView {

    var app : AppDelegate!
    
    func setup(app: AppDelegate) {
        self.app = app
        editable = false
        selectable = false
        drawsBackground = false
        delegate = self
    }
    
}

extension SummaryTextView: NSTextViewDelegate {
    override func mouseDown(theEvent: NSEvent) {
        app.tableView.mouseDown(theEvent)
        super.mouseDown(theEvent)
    }
}
