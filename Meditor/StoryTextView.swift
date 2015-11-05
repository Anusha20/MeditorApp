//
//  MasterViewController.swift
//

import Cocoa

class MeditorTextView: NSTextView {
    
    var story : Story!
    var app : AppDelegate!
    var isLastKeyDelete = false
    
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
        if(story.isEmpty()) {
            showStory(placeholder, selectedRange: NSRange(location: 0,length: 0), selectedAlpha: 0.3)
            app.publishButton.enabled = false
            refreshInfo("Editing Draft")
        } else if(story.isExported()) {
            showStory(story.body, selectedRange: selectedRange(), selectedAlpha: 0.3)
            app.publishButton.enabled = false
            refreshInfo("Exported to medium.com")
        } else {
            showStory(story.body, selectedRange: selectedRange(), selectedAlpha: 0.7)
            app.publishButton.enabled = true
            refreshInfo("Editing Draft")
        }
        formatMarkdown();
    }
    
    func storyChanged() {
        setSelectedRange(NSRange(location: 0,length: 0))
        textChanged()
        if(story.isExported()) {
            editable = false
            selectable = false
            backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.03)
        } else {
            editable = true
            selectable = true
            backgroundColor = NSColor.clearColor()
        }
        
    }
    
    func refreshInfo(message : String) {
        let wordsCount = story.wordCount()
        app.infoField.showIdle(story.shorten(story.getTitle(), count: 30), words: wordsCount, mins: story.minsCount(wordsCount), message: message)
    }
    
    func updateStory() {
        if(story.isEmpty()) {
            story.body = string!.substringToIndex(string!.rangeOfString(placeholder)!.startIndex)
        } else {
            story.body = string!
        }
        story.save()
        Stories.sharedInstance.updateStory(Stories.sharedInstance.getCurrentStory(), story: story)
        if let view = app.tableView.viewAtColumn(0, row: Stories.sharedInstance.getCurrentStory(), makeIfNecessary: false) {
            (view.subviews[0]  as! NSTextField).attributedStringValue = Stories.sharedInstance.getAttributedSummary(Stories.sharedInstance.getCurrentStory())
        }
    }
    
    func addAutoAddtion(){
        var isordered = false
        var regex:NSRegularExpression = try! NSRegularExpression(pattern: "(\\n|^)(\\s*)(\\*|-|\\+)\\s(.+)\\n$", options: [NSRegularExpressionOptions.AnchorsMatchLines])
        let range = NSMakeRange(0, (string?.characters.count)!)
        var matches = regex.matchesInString(string!, options: [], range: range)
        let index:Int  = 3
        if(matches.isEmpty){
            regex = try! NSRegularExpression(pattern: "(\\n|^)(([0-9]+)\\.)\\s(.+)\\n$", options: [NSRegularExpressionOptions.AnchorsMatchLines])
            matches = regex.matchesInString(string!, options: [], range: range)
            if(!matches.isEmpty){
                isordered = true
            }
        }
        
        
        var tempRange = selectedRange()
        
        for match in matches{
            if(!isLastKeyDelete){
                let r:NSRange = match.rangeAtIndex(index)
                let endIndex = string!.startIndex.advancedBy(r.location+r.length)
                let range:Range<String.Index> = Range<String.Index>(start: string!.startIndex.advancedBy(r.location),end:endIndex )
                let char = string!.substringWithRange(range)
                let endLocation:Int = match.range.location + match.range.length
                             //   if(endLocation == string?.characters.count && string?.characters.last == "\n"){
                    if(!isordered){
                        let ele = "\n"+char + " "
                        let replaceRange:Range<String.Index> = Range<String.Index>(start: string!.startIndex.advancedBy(endLocation-1),end: string!.startIndex.advancedBy(endLocation))
                        string?.replaceRange(replaceRange, with: ele)
                        tempRange.location = tempRange.location + ele.characters.count-1
                        
                    
                    }else{
                        var num = Int(char)
                        num = num! + 1
                        let str = "\n"+String(num!) + ". "
                        let replaceRange:Range<String.Index> = Range<String.Index>(start: string!.startIndex.advancedBy(endLocation-1),end: string!.startIndex.advancedBy(endLocation))
                        string?.replaceRange(replaceRange, with: str)
                        
                        tempRange.location = tempRange.location + str.characters.count-1
                        
                        
                    }
                setSelectedRange(tempRange)
               // }
            }
            
        }
        if(matches.isEmpty){
            regex = try! NSRegularExpression(pattern: "(\\s*)(\\*|-|\\+)\\s\\n$", options: [NSRegularExpressionOptions.AnchorsMatchLines])
            matches = regex.matchesInString(string!, options: [], range: range)
            if(matches.isEmpty){
                regex = try! NSRegularExpression(pattern: "(([0-9]+)\\.)\\s\\n$", options: [NSRegularExpressionOptions.AnchorsMatchLines])
                matches = regex.matchesInString(string!, options: [], range: range)
                if(!matches.isEmpty){
                    isordered = true
                }
            }
                for match in matches{
                    let r : NSRange = match.range;
                    let replaceRange:Range<String.Index> = Range<String.Index>(start: string!.startIndex.advancedBy(r.location),end: string!.startIndex.advancedBy(r.location + r.length))
                    string?.replaceRange(replaceRange, with: "\n")
                    tempRange.location = tempRange.location - r.length + 1
                }
            

            
        }
        
    }
    
    override func keyDown(theEvent: NSEvent) {
        func intToString(x : Int) -> String {
            return String(UnicodeScalar(x))
        }
        
        switch theEvent.keyCode {
            
        case 51:
            isLastKeyDelete = true
            break
        default:
            isLastKeyDelete = false

        }
        super.keyDown(theEvent)
    }
    
    // Markdown
    
    func formatMarkdown() {
        addAutoAddtion()
        let attributedText = attributedString().mutableCopy() as! NSMutableAttributedString
        MarkDownFormatter.sharedInstance.formatMarkdown(attributedText,string:string,lowAlpha: story.isEmpty() || story.isExported())
        
        let tempRange = selectedRange()
        textStorage!.setAttributedString(attributedText.copy() as! NSAttributedString)
        setSelectedRange(tempRange)
    }
    
    override func cancelOperation(sender: AnyObject?) {
        app.window.makeFirstResponder(app.tableView)
        super.cancelOperation(sender)
    }

    
}

extension MeditorTextView: NSTextViewDelegate {
    
    func textDidChange(notification: NSNotification) {
        updateStory()
        textChanged()
    }
    
    func textViewDidChangeSelection(notification: NSNotification) {
        if(story.isEmpty() && string == placeholder && (selectedRange().location != 0 || selectedRange().length != 0)) {
            setSelectedRange(NSRange(location: 0,length: 0))
        }
    }
    
}
