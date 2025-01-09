
import Flutter
import UIKit
import app_links

// This can be used for multiple flutters, but sadly it does not work well enough to be used.
// When using multiple views sharing no longer works, starting the app results in a splashscreen-less start, which is ugly and when opening documents in one view, it can open in another.
// This can probably all be fixed, but I have too little understanding of swift and apple's way of doing things, so for now this file is unused.
// Feel free to finish what I started, because this feature woule be great to have on iPad's where you sometimes need more than one Discipulus instance.

final class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            preconditionFailure("unable to obtain AppDelegate")
        }
        
        let window = UIWindow(windowScene: windowScene)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
           // Set the window property of the AppDelegate
           appDelegate.window = window
        }
        
        let flutterEngine = appDelegate.engines.makeEngine(
            withEntrypoint: nil,
            libraryURI: nil
        )
        
        print("Registering plugins with new engine")
        
        GeneratedPluginRegistrant.register(with: flutterEngine)
        
        let viewController = FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil
        )
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
          for context in URLContexts {
            AppLinks.shared.handleLink(url: context.url)
          }
        }
        
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
      if let url = userActivity.webpageURL {
        AppLinks.shared.handleLink(url: url)
      }
    }
}
