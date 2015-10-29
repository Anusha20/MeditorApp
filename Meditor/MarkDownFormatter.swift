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
    var placeHolderColor = NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
    
    var h1:Attribute!
    var h2:Attribute!
    var emphasis:Attribute!
    var strongemphasis:Attribute!
    var UnOrderedList:Attribute!
    var OrderedList:Attribute!
    var link:Attribute!
    

    
    class Attribute{
        var font:NSFont!
        var regex:NSRegularExpression!
        var para:NSMutableParagraphStyle!
        var syntaxRangeIndex:[Int] = []
        var italics: NSNumber = 0
        var color: NSColor = NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.9)
        var isBullet:Bool = false
        
        
    }
    
    func  H1init(){
        h1 = Attribute()
        h1.font = NSFont(name: "HelveticaNeue-Bold", size: 36)!
        h1.regex = try! NSRegularExpression(pattern: "((\\n|^)# +)(.*)", options: [])
        h1.syntaxRangeIndex = [1]
        h1.para = getDefaultParagrahStyle()
    }
    
    
    func  H2Init(){
        h2 = Attribute()
        h2.font = NSFont(name: "HelveticaNeue-Bold", size: 30)!
        h2.regex = try! NSRegularExpression(pattern: "((\\n|^)## +)(.*)", options: [])
        h2.syntaxRangeIndex = [1]
        h2.para = getDefaultParagrahStyle()
        
    }
    
    func strongEmphasisInit(){
        strongemphasis = Attribute()
        strongemphasis.font = NSFont(name: "Charter-Bold", size: 20.5)!
        strongemphasis.regex = try! NSRegularExpression(pattern: "(\\*\\*|__)(.*?)(\\*\\*|__)", options: [])
        strongemphasis.syntaxRangeIndex = [1,3]
        
        
        
    }
    
    func emphasisInit(){
        emphasis = Attribute()
        emphasis.font = NSFont(name: "Charter", size: 20.5)!
        emphasis.regex = try! NSRegularExpression(pattern: "(\\*|_)(.*?)(\\*|_)", options: [])
        emphasis.syntaxRangeIndex = [1,3]
        emphasis.italics = 0.20
        
    }
    
    func UnOrderedListInit(){
        UnOrderedList = Attribute()
        UnOrderedList.font = NSFont(name: "Charter", size: 20.5)!
        UnOrderedList.regex = try! NSRegularExpression(pattern: "((\\n|^)(\\s*)(\\*|-|\\+)\\s)(.*)", options: [])
        UnOrderedList.syntaxRangeIndex = []
        UnOrderedList.para = getListParagraphStyle()
        UnOrderedList.isBullet = true
    }
    
    func OrderedListInit(){
        OrderedList = Attribute()
        OrderedList.font = NSFont(name: "Charter", size: 20.5)!
        OrderedList.regex = try! NSRegularExpression(pattern: "((\\n|^)(\\s*)([0-9]+\\.)\\s)(.*)", options: [])
        OrderedList.syntaxRangeIndex = []
        OrderedList.para = getListParagraphStyle()
        OrderedList.isBullet = true
    }
    
    func linkInit(){
        link = Attribute()
        link.font = NSFont(name: "Charter", size: 20.5)!
        link.regex = try! NSRegularExpression(pattern: "(\\[)([^\\[]+)(\\]\\()([^\\)]+)(\\))", options: [])
        link.syntaxRangeIndex = [1,3,5]
        link.color = NSColor(red: 0.0, green: 0.0, blue: 0.7, alpha: 0.9)
        
        
    }
    
    //\[([^\[]+)\]\(([^\)]+)\)
    //((\n|^)\s*([0-9]+\.)\s)(.*)
    
    // Markdown
    ///(#+)(.*)/
    
    func  setup(){
        
        H1init()
        H2Init()
        strongEmphasisInit()
        emphasisInit()
        UnOrderedListInit()
        OrderedListInit()
        linkInit()
        
    }
    func formatMarkDownSyntax(attributedText:NSMutableAttributedString,range : NSRange){
        attributedText.addAttribute(NSForegroundColorAttributeName, value: NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.07), range: range)
    }
    
    func getDefaultParagrahStyle() -> NSMutableParagraphStyle{
        let style = NSMutableParagraphStyle();
        style.lineSpacing = -10;
        style.lineHeightMultiple = 1.2
        style.paragraphSpacing = 5
        style.paragraphSpacingBefore = 30
        return style
    }
    
    func getListParagraphStyle() -> NSMutableParagraphStyle {
        //let tabs:NSTextTab = NSTextTab.init(textAlignment: NSTextAlignment.Left,location:1.0, options:[:])
        let paraStyle = NSMutableParagraphStyle()
        //  paraStyle.setTabStops
        paraStyle.defaultTabInterval = 5.0
        paraStyle.firstLineHeadIndent = 0.0
        //[para setHeaderLevel:0];
        paraStyle.headIndent = 1.0
        paraStyle.paragraphSpacing = 1
        paraStyle.paragraphSpacingBefore = 1.5
        paraStyle.lineSpacing = -5;
        paraStyle.lineHeightMultiple = 1.2
        
        return paraStyle
    }
    
    
   
    
    
    
    func formatText( attributedText:NSMutableAttributedString!,format : Attribute, string : String?,isEmpty:Bool) -> Bool  {
        var matched:Bool = false
        let range = NSMakeRange(0, (string?.characters.count)!)
        let matches = format.regex.matchesInString(string!, options: [], range: range)
        for match in matches {
            matched = true
            let matchRange = match.range
            attributedText.addAttribute(NSFontAttributeName, value: format.font, range: matchRange)
            attributedText.addAttribute(NSObliquenessAttributeName, value: format.italics, range: matchRange)
            if(format.para != nil){
                attributedText.addAttribute(NSParagraphStyleAttributeName, value: format.para, range: matchRange)
            }
            if(isEmpty) {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: placeHolderColor, range: matchRange)
            } else {
                attributedText.addAttribute(NSForegroundColorAttributeName, value: format.color, range: matchRange)
            }
            for index in format.syntaxRangeIndex{
                formatMarkDownSyntax(attributedText,range: match.rangeAtIndex(index))
            }
        }
        return matched;
    }
    
    func formatMarkdown(attributedText:NSMutableAttributedString!,string : String?,isEmpty:Bool) {
        
        formatText(attributedText,format:h1,string : string,isEmpty:isEmpty)
        formatText(attributedText,format:h2,string : string,isEmpty:isEmpty)
        formatText(attributedText,format:emphasis,string : string,isEmpty:isEmpty)
        formatText(attributedText,format:strongemphasis,string : string,isEmpty:isEmpty)
        var isUnOrderedlist = formatText(attributedText,format:UnOrderedList,string : string,isEmpty:isEmpty)
        var isOrderedlist = formatText(attributedText,format:OrderedList,string : string,isEmpty:isEmpty)
        formatText(attributedText,format:link,string : string,isEmpty:isEmpty)
        
        
    }
    
    
}