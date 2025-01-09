// Spotlight
import CoreSpotlight
import Flutter
import UIKit
import app_links
import flutter_apple_spotlight
import flutter_apple_handoff
import flutter_local_notifications
import workmanager
import home_widget

@main
@objc class AppDelegate: FlutterAppDelegate, NSUserActivityDelegate {
  let engines = FlutterEngineGroup(name: "SharedEngine", project: nil)

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)  // This has to be removed when using multiple views, because in that case the plugins will be registered per view

    //  Background refresh
    WorkmanagerPlugin.registerTask(
      withIdentifier: "dev.harrydekat.discipulus.discipulusQuickrefresh")
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }
    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60 * 30))

    //  Notifications
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
      
      // Home Widgets
      if #available(iOS 17, *) {
       HomeWidgetBackgroundWorker.setPluginRegistrantCallback { registry in
           GeneratedPluginRegistrant.register(with: registry)
       }
      }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
//  // Spotlight & Handoff
//    override func application(_ application: UIApplication, continue userActivity: NSUserActivity,
//                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//      
//    // Handoff
//    if let isHandoff = userActivity.userInfo?["isHandoff"] as? Bool, isHandoff {
//         // This is a handoff activity
//         userActivity.resignCurrent()
//         userActivity.invalidate()
//         SwiftFlutterAppleHandoffPlugin.handleUserActivity(userActivity: userActivity)
//         return true
//     }
//      
//    // Spotlight
//    if userActivity.activityType == CSSearchableItemActionType {
//        userActivity.resignCurrent()
//        userActivity.invalidate()
//        SwiftFlutterAppleSpotlightPlugin.pressedCallback(userActivity: userActivity)
//        return true
//    }
//        
//        print("Could not handle \(String(describing: userActivity.userInfo))")
//      
//    return false
//  }
}
