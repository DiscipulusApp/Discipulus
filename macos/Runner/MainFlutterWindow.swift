import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
      
      flutterViewController.backgroundColor = .clear
    
  
      
      let visualEffectView = NSVisualEffectView()
       visualEffectView.material = .underWindowBackground
       visualEffectView.blendingMode = .behindWindow
       visualEffectView.state = .active
      flutterViewController.view.addSubview(visualEffectView, positioned: .below, relativeTo: flutterViewController.view)
       visualEffectView.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
        visualEffectView.topAnchor.constraint(equalTo: flutterViewController.view.topAnchor),
        visualEffectView.bottomAnchor.constraint(equalTo: flutterViewController.view.bottomAnchor),
        visualEffectView.leadingAnchor.constraint(equalTo: flutterViewController.view.leadingAnchor),
        visualEffectView.trailingAnchor.constraint(equalTo:flutterViewController.view.trailingAnchor),
       ])
      
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
