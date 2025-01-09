import Cocoa
import FlutterMacOS
import flutter_apple_spotlight
import flutter_apple_handoff
import CoreSpotlight

@main
class AppDelegate: FlutterAppDelegate, NSUserActivityDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
    
    // Spotlight & Handoff
    override func application(
        _ application: NSApplication, continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void
      ) -> Bool {
          
          // Handoff
          if let isHandoff = userActivity.userInfo?["isHandoff"] as? Bool, isHandoff {
             // This is a handoff activity
             userActivity.resignCurrent()
             userActivity.invalidate()
             SwiftFlutterAppleHandoffPlugin.handleUserActivity(userActivity: userActivity)
             return true
         }
          
          // Spotlight
          if userActivity.activityType == CSSearchableItemActionType {
              // Activity is from spotlight, sending it to the handoff plugin
              userActivity.resignCurrent()
              userActivity.invalidate()
              SwiftFlutterAppleSpotlightPlugin.pressedCallback(userActivity: userActivity)
              return true
          }
        return false
      }
}
