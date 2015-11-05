//
//  SummaryTextView.swift
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
