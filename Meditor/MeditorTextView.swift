//
//  MasterViewController.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/12/15.
//  Copyright © 2015 Meditor. All rights reserved.
//

import Cocoa

class MeditorTextView: NSTextView {
    
    var story : Story!
    var app : AppDelegate!
    
    
    let placeholder = "# Title\nTell your story...";
    
    func setup(app : AppDelegate, story: Story) {
        self.story = story
        self.app = app
        
        continuousSpellCheckingEnabled = false;
        storyChanged()
    }
    
    func showStory(title: String, selectedRange: NSRange, selectedAlpha: CGFloat) {
        
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
    
    func textChanged() {
        if(story.body.isEmpty) {
            showStory(placeholder, selectedRange: NSRange(location: 0,length: 0), selectedAlpha: 0.3)
        } else {
            showStory(story.body, selectedRange: selectedRange(), selectedAlpha: 0.7)
        }
        formatMarkdown();
        refreshInfo()
    }

    func storyChanged() {
        setSelectedRange(NSRange(location: 0,length: 0))
        textChanged()
    }
    
    func refreshInfo() {
        let wordsCount = story.wordCount()
        app.infoField.showIdle(story.shorten(story.getTitle(), count: 40), words: wordsCount, mins: story.minsCount(wordsCount), message: "Editing Draft")
    }
    
    func updateStory() {
        if(story.body.isEmpty) {
            story.body = string!.substringToIndex(string!.rangeOfString(placeholder)!.startIndex)
        } else {
            story.body = string!
        }
        story.save()
        Stories.sharedInstance.updateStory(Stories.sharedInstance.getCurrentStory(), story: story)
        (app.tableView.viewAtColumn(0, row: Stories.sharedInstance.getCurrentStory(), makeIfNecessary: false)  as! SummaryTextView).string = Stories.sharedInstance.getSummary(Stories.sharedInstance.getCurrentStory())
    }
    
    // Markdown
    
    func formatMarkdown() {
        
        let attributedText = attributedString().mutableCopy() as! NSMutableAttributedString
        
        //let attributedTextRange = NSMakeRange(0, attributedText.length)
        //attributedText.removeAttribute(NSBackgroundColorAttributeName, range: attributedTextRange)
        
        // Header
        
        /*var regex = try! NSRegularExpression(pattern: "^(# +)(.*)", options: [])
        var range = NSMakeRange(0, (string?.characters.count)!)
        var matches = regex.matchesInString(string!, options: [], range: range)
        
        for match in matches {
            let matchRange = match.range
            attributedText.addAttribute(NSFontAttributeName, value: NSFont(name: "HelveticaNeue-Bold", size: 36)!, range: matchRange)
            let style = NSMutableParagraphStyle();
            style.lineSpacing = -10;
            style.lineHeightMultiple = 1.2
            style.paragraphSpacing = 5
            style.paragraphSpacingBefore = 30
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: matchRange)
            if(story.body.isEmpty) {
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
            attributedText.addAttribute(NSFontAttributeName, value: NSFont(name: "HelveticaNeue-Bold", size: 36)!, range: matchRange)
            let style = NSMutableParagraphStyle();
            style.lineSpacing = -10;
            style.lineHeightMultiple = 1.2
            style.paragraphSpacing = 5
            style.paragraphSpacingBefore = 30
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: matchRange)
            if(story.body.isEmpty) {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), range: matchRange)
            } else {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.9), range: matchRange)
            }
            
        }*/
        
        MarkDownFormatter.sharedInstance.formatMarkdown(attributedText,string:string,story:story)
        
        let tempRange = selectedRange()
        textStorage!.setAttributedString(attributedText.copy() as! NSAttributedString)
        setSelectedRange(tempRange)
    }
    
}

extension MeditorTextView: NSTextViewDelegate {
    
    func textDidChange(notification: NSNotification) {
        updateStory()
        textChanged()
    }
    
    func textViewDidChangeSelection(notification: NSNotification) {
        if(story.body.isEmpty && string == placeholder && (selectedRange().location != 0 || selectedRange().length != 0)) {
            setSelectedRange(NSRange(location: 0,length: 0))
        }
    }
    
}