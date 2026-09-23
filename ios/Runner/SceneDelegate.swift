import Flutter
import UIKit
import app_links

class SceneDelegate: FlutterSceneDelegate {
    override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        super.scene(scene, openURLContexts: URLContexts)
        for context in URLContexts {
            AppLinks.shared.handleLink(url: context.url)
        }
    }
    
    override func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        super.scene(scene, continue: userActivity)
        if let url = userActivity.webpageURL {
            AppLinks.shared.handleLink(url: url)
        }
    }
}
