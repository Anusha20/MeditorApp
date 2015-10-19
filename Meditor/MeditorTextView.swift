//
//  MasterViewController.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/12/15.
//  Copyright © 2015 Meditor. All rights reserved.
//

import Cocoa

class MeditorTextView: NSTextView {

    var meditorDoc = MeditorDoc()
    
    var isEmpty = true
    let placeholder = "# Title\nTell your story...";
    
    func setup() {
        resetTitle()
        continuousSpellCheckingEnabled = false;
        formatMarkdown()
        setupSampleDoc()
    }

    func resetTitle() {
        changeTitle(placeholder, selectedRange: NSRange(location: 0,length: 0), selectedAlpha: 0.3)
    }
    
    func changeTitle(title: String, selectedRange: NSRange, selectedAlpha: CGFloat) {
        
        let style = NSMutableParagraphStyle();
        style.lineHeightMultiple = 1.3
        style.lineSpacing = 0;
        style.paragraphSpacing = 30
        style.paragraphSpacingBefore = 0
        
        let myAttributedstring = NSMutableAttributedString(string: title,
            attributes: [
                NSFontAttributeName : NSFont(name: "Charter", size: 20.5)!,
                NSForegroundColorAttributeName: NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: selectedAlpha),
                NSParagraphStyleAttributeName: style
            ]
        )
        
        textStorage!.setAttributedString(myAttributedstring)
        setSelectedRange(selectedRange)
    }
    
    func formatMarkdown() {

        let attributedText = attributedString().mutableCopy() as! NSMutableAttributedString

        //let attributedTextRange = NSMakeRange(0, attributedText.length)
        //attributedText.removeAttribute(NSBackgroundColorAttributeName, range: attributedTextRange)

        // Header
        
        var regex = try! NSRegularExpression(pattern: "^(# +)(.*)", options: [])
        var range = NSMakeRange(0, (string?.characters.count)!)
        var matches = regex.matchesInString(string!, options: [], range: range)
        
        for match in matches {
            let matchRange = match.range
            attributedText.addAttribute(NSFontAttributeName, value: NSFont(name: "MyriadPro-Semibold", size: 36)!, range: matchRange)
            let style = NSMutableParagraphStyle();
            style.lineSpacing = -10;
            style.lineHeightMultiple = 1.2
            style.paragraphSpacing = 5
            style.paragraphSpacingBefore = 30
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: matchRange)
            if(isEmpty) {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), range: matchRange)
            } else {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.9), range: matchRange)
            }
        }
        
        regex = try! NSRegularExpression(pattern: "(\\n# +)(.*)", options: [])
        range = NSMakeRange(0, (string?.characters.count)!)
        matches = regex.matchesInString(string!, options: [], range: range)
        
        for match in matches {
            let matchRange = match.range
            attributedText.addAttribute(NSFontAttributeName, value: NSFont(name: "MyriadPro-Semibold", size: 36)!, range: matchRange)
            let style = NSMutableParagraphStyle();
            style.lineSpacing = -10;
            style.lineHeightMultiple = 1.2
            style.paragraphSpacing = 5
            style.paragraphSpacingBefore = 30
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: matchRange)
            if(isEmpty) {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), range: matchRange)
            } else {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.9), range: matchRange)
            }

        }
    
        let tempRange = selectedRange()
        textStorage!.setAttributedString(attributedText.copy() as! NSAttributedString)
        setSelectedRange(tempRange)
    }
    
    func setupSampleDoc() {
        meditorDoc = MeditorDoc(title: "Sample Title", body: "Sample Body")
    }
}

extension MeditorTextView: NSTextViewDelegate {
    
    func textDidChange(notification: NSNotification) {
        if(!isEmpty) {
            if(string == "") {
                isEmpty = true
                resetTitle()
            } else {
                changeTitle(string!, selectedRange: selectedRange(), selectedAlpha: 0.7)
            }
        } else {
            if((string?.rangeOfString(placeholder)) != nil) {
                isEmpty = false
                changeTitle(string!.substringToIndex(string!.rangeOfString(placeholder)!.startIndex), selectedRange: NSRange(location: string!.startIndex.distanceTo(string!.rangeOfString(placeholder)!.startIndex), length: 0), selectedAlpha: 0.7)
            }
        }
        
        formatMarkdown();
    }
    
    func textViewDidChangeSelection(notification: NSNotification) {
        if(isEmpty && (selectedRange().location != 0 || selectedRange().length != 0)) {
            setSelectedRange(NSRange(location: 0,length: 0))
        }
    }

}