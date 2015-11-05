//
//

import Cocoa

class StoriesButton: NSButton {

    var app : AppDelegate?
    
    init(frame: NSRect, app: AppDelegate) {
        super.init(frame: frame)
        self.app = app
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    override func mouseEntered(theEvent: NSEvent) {
        app?.infoField.showTooltip(toolTip!)
    }
    
    override func mouseExited(theEvent: NSEvent) {
        app?.infoField.showLast()
    }

    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        for trackingArea : NSTrackingArea in trackingAreas {
            removeTrackingArea(trackingArea)
        }
        addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingAreaOptions(rawValue: NSTrackingAreaOptions.InVisibleRect.rawValue | NSTrackingAreaOptions.MouseEnteredAndExited.rawValue | NSTrackingAreaOptions.ActiveInKeyWindow.rawValue), owner: self, userInfo: nil))
    }
    
}
