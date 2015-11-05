//
//  InfoTextField.swift
//

import Cocoa

class InfoTextField: NSTextField {

    var progress : CGFloat = 0;
    var idleTitle = ""
    var idleWords = 0
    var idleMins = 0
    var idleMessage = ""

    var lastMessage = ""
    var lastProgress : CGFloat = 0
    
    override func drawRect(dirtyRect: NSRect) {

        super.drawRect(dirtyRect)
        
        var progressRect = bounds;
        progressRect.origin.x = 2;
        progressRect.origin.y = progressRect.size.height - 4 ;
        progressRect.size.width *= progress;
        progressRect.size.width -= CGFloat(4.0)
        progressRect.size.height = 2;
        
        NSColor(calibratedRed: 0.0, green: 0.0, blue: 1.0, alpha: 0.6 ).set()
        NSRectFillUsingOperation(progressRect, NSCompositingOperation.CompositeSourceOver);

    }
    
    func showTooltip(tooltip : String) {
        alignment = NSTextAlignment.Center
        stringValue = tooltip
        progress = 0
    }
    
    func showProgress(progressMessage : String, progressValue: CGFloat) {
        alignment = NSTextAlignment.Left
        stringValue = "\(idleTitle)  |  \(progressMessage)"
        progress = progressValue
        saveLast()
    }

    func showIdle(title: String, words : Int, mins : Int, message : String) {
        idleTitle = title
        idleWords = words
        idleMins = mins
        idleMessage = message
        showIdle()
        saveLast()
    }
    
    func showIdle() {
        alignment = NSTextAlignment.Left
        stringValue = "\(idleTitle)  |  \(idleMessage)  -  \(idleWords) words (\(idleMins) mins)"
        progress = 0
        saveLast()
    }
    
    func showLast() {
        alignment = NSTextAlignment.Left
        stringValue = lastMessage
        progress = lastProgress
    }
    
    func saveLast() {
        lastMessage = stringValue
        lastProgress = progress
    }
    
}
