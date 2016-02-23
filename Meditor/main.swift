
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