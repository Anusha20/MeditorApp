//
//  main.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/17/15.
//  Copyright © 2015 Meditor. All rights reserved.
//

import Cocoa

let app = NSApplication.sharedApplication()

// Setting up App Delegate
let delegate = AppDelegate()
app.delegate = delegate

// Setting up the Main Menu
app.menu = MenuDelegate()

// Starting the App
app.setActivationPolicy(.Regular)
atexit_b { app.setActivationPolicy(.Prohibited); return }
app.run()