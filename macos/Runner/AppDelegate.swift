import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }
  
  override func applicationDidFinishLaunching(_ notification: Notification) {
    let controller : FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
    
    // Make window transparent
    mainFlutterWindow?.isOpaque = false
    mainFlutterWindow?.backgroundColor = NSColor.clear
    mainFlutterWindow?.level = .floating
    mainFlutterWindow?.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
    
    super.applicationDidFinishLaunching(notification)
  }
}
