//
//  MeditorDoc.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/12/15.
//  Copyright © 2015 Meditor. All rights reserved.
//

import Foundation
import AppKit

class MeditorDoc: NSObject {

    var title: String
    var body: String
        
    override init() {
        self.title = String()
        self.body = String()
    }
        
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
    
}
