import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    
    // Configure window for transparency
    self.isOpaque = false
    self.backgroundColor = NSColor.clear
    self.styleMask = [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView]
    self.titlebarAppearsTransparent = true
    self.titleVisibility = .hidden
    
    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
