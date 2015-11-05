//
//

import Foundation
import AppKit
import Cocoa

class Story: NSObject {

    var body: String
    var id : String
    var mediumURL : String!
    
    let titleLength = 40
        
    override init() {
        self.body = String()
        self.id = NSUUID().UUIDString
    }
    
    init(id: String) {
        self.id = id

        let documentsUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
        let fileUrl = documentsUrl.URLByAppendingPathComponent(id + ".md")
        self.body = try! String(contentsOfURL: fileUrl, encoding: NSUTF8StringEncoding)
    }
    
    convenience init(id: String, mediumURL: String) {
        self.init(id: id)
        self.mediumURL = mediumURL
    }
 
    func save(){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let documentsUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
            let fileUrl = documentsUrl.URLByAppendingPathComponent(self.id+".md")
            try! self.body.writeToURL(fileUrl, atomically: true, encoding: NSUTF8StringEncoding)
            
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
            }
        }
    }
    
    func getSummary() -> [String:AnyObject] {
        let summary = getTitle() + "\n" + getText()
        if(mediumURL == nil) {
            return ["id": id, "summary": shorten(summary, count: 100), "titleLength": (getTitle().characters.count < 100) ? getTitle().characters.count : 100]
        } else {
            return ["id": id, "summary": shorten(summary, count: 100), "titleLength": (getTitle().characters.count < 100) ? getTitle().characters.count : 100, "mediumURL" : mediumURL]
        }
    }
    
    func getTitle() -> String {
        var title : String
        if(isEmpty()) {
            return "Untitled"
        } else {
            if((body.rangeOfString("\n")) != nil) {
                title = (body.substringToIndex((body.rangeOfString("\n")?.startIndex)!))
            } else {
                title = body
            }
        }
        title = title.stringByReplacingOccurrencesOfString("## ", withString: "")
        title = title.stringByReplacingOccurrencesOfString("##", withString: "")
        title = title.stringByReplacingOccurrencesOfString("# ", withString: "")
        title = title.stringByReplacingOccurrencesOfString("#", withString: "")
        return title
    }
    
    func getText() -> String {
        var text : String
        if(isEmpty()) {
            return ""
        } else {
            if((body.rangeOfString("\n")) != nil) {
                text = (body.substringFromIndex((body.rangeOfString("\n")?.startIndex.advancedBy(1))!))
            } else {
                text = ""
            }
        }
        text = text.stringByReplacingOccurrencesOfString("\n", withString: " ")
        text = text.stringByReplacingOccurrencesOfString("## ", withString: "")
        text = text.stringByReplacingOccurrencesOfString("##", withString: "")
        text = text.stringByReplacingOccurrencesOfString("# ", withString: "")
        text = text.stringByReplacingOccurrencesOfString("#", withString: "")
        return text
    }
    
    func wordCount() -> Int {
        return (body.componentsSeparatedByString(" ").count)
    }
    
    func isEmpty() -> Bool {
        return body.isEmpty
    }
    
    func isExported() -> Bool {
        return mediumURL != nil
    }
    
    //Uitls
    
    func shorten(text : String, count : Int) -> String {
        if(text.characters.count <= count) {
            return text
        } else {
            return text.substringToIndex(text.startIndex.advancedBy(count)) + "..."
        }
    }

    func minsCount(wordCount : Int) -> Int {
        return Int(round(Double(wordCount) / 220.0))
    }
}

    

