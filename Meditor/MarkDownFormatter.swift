//
//  Formatter.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/27/15.
//  Copyright © 2015 Meditor. All rights reserved.
//

import Foundation
import Cocoa
import AppKit


class MarkDownFormatter : NSObject{
    
    
    static let sharedInstance = MarkDownFormatter()
    
        // Markdown
    ///(#+)(.*)/
    
    func heading1(attributedText:NSMutableAttributedString!,string : String?,story:Story) {
        var regex = try! NSRegularExpression(pattern: "^(#\\s+)(.*)", options: [])
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
        
    }
    
    func heading2(attributedText:NSMutableAttributedString!,string : String?,story:Story){
        var regex = try! NSRegularExpression(pattern: "(##\\s+)(.*)", options: [])
        var range = NSMakeRange(0, (string?.characters.count)!)
        var matches = regex.matchesInString(string!, options: [], range: range)
        for match in matches {
            let matchRange = match.range
            attributedText.addAttribute(NSFontAttributeName, value: NSFont(name: "HelveticaNeue-Bold", size: 30)!, range: matchRange)
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
    }
    
    
    
    
    func strongemphasis(attributedText:NSMutableAttributedString!,string : String?,story:Story){
        var regex = try! NSRegularExpression(pattern: "(\\*\\*|__)(.*?)\\1", options: [])
        var range = NSMakeRange(0, (string?.characters.count)!)
        var matches = regex.matchesInString(string!, options: [], range: range)
        for match in matches {
            let matchRange = match.range
            attributedText.addAttribute(NSFontAttributeName, value: NSFont(name: "HelveticaNeue-Bold", size: 20.5)!, range: matchRange)
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
    }
    
    //"(\\*([^\\*]*)\\*)"
    func emphasis(attributedText:NSMutableAttributedString!,string : String?,story:Story){
        var regex = try! NSRegularExpression(pattern: "(\\*|_)(.*?)\\1", options: [])
        var range = NSMakeRange(0, (string?.characters.count)!)
        var matches = regex.matchesInString(string!, options: [], range: range)
        for match in matches {
            let matchRange = match.range
             let numberWithFloat:NSNumber = 0.20
            attributedText.addAttribute(NSObliquenessAttributeName, value: numberWithFloat, range: matchRange)
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
    }
    
  /*  func blockQuote (attributedText:NSMutableAttributedString!,string : String?,story:Story){
        var regex = try! NSRegularExpression(pattern: "(\\*\\*|__)(.*?)\\1", options: [])
        var range = NSMakeRange(0, (string?.characters.count)!)
        var matches = regex.matchesInString(string!, options: [], range: range)
        for match in matches {
            let matchRange = match.range
            attributedText.addAttribute(NSFontAttributeName, value: NSFont(name: "HelveticaNeue-Bold", size: 20.5)!, range: matchRange)
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
    }*/

    func unOrderedList(attributedText:NSMutableAttributedString!,string : String?,story:Story){
        var regex = try! NSRegularExpression(pattern: "(^\\s*(\\*|-)\\s)(.*)", options: [])
        var range = NSMakeRange(0, (string?.characters.count)!)
        var matches = regex.matchesInString(string!, options: [], range: range)
        
        var tabs:NSTextTab = NSTextTab.init(textAlignment: NSTextAlignment.Left,location:1.0, options:[:])
        let paraStyle = NSMutableParagraphStyle()
      //  paraStyle.setTabStops
       // paraStyle.firstLineHeadIndent = 15.0
//paraStyle.paragraphSpacingBefore = 10.0
        
        paraStyle.defaultTabInterval = 2.0
        paraStyle.firstLineHeadIndent = 0.0
        //[para setHeaderLevel:0];
        paraStyle.headIndent = 1.0
        paraStyle.paragraphSpacing = 3
        paraStyle.paragraphSpacingBefore = 3
        
        for match in matches {
            let matchRange = match.range
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paraStyle, range: matchRange)
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
    }
    
    
    func formatMarkdown(attributedText:NSMutableAttributedString!,string : String?,story:Story) {
        
        heading1(attributedText,string : string,story:story)
        heading2(attributedText,string : string,story:story)
        emphasis(attributedText,string : string,story:story)
        strongemphasis(attributedText,string : string,story:story)
        unOrderedList(attributedText,string : string,story:story)
        
       /// let attributedText = attributedString().mutableCopy() as! NSMutableAttributedString
        
        //let attributedTextRange = NSMakeRange(0, attributedText.length)
        //attributedText.removeAttribute(NSBackgroundColorAttributeName, range: attributedTextRange)
        
        // Header
        
/*        var regex = try! NSRegularExpression(pattern: "^(# +)(.*)", options: [])
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
            
        }
        
        let tempRange = selectedRange()
        textStorage!.setAttributedString(attributedText.copy() as! NSAttributedString)
        setSelectedRange(tempRange) */
    }
    
    
}