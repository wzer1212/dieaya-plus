import Flutter
import UIKit
import flutter_local_notifications // Add this import
import FirebaseCore


@main
@objc class AppDelegate: FlutterAppDelegate {

    // Store the link if app was launched from terminated state
    var initialLink: String?

    // Called when the app finishes launching
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        print("🔥 Native AppDelegate: didFinishLaunching")

        // Local notifications setup
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
            GeneratedPluginRegistrant.register(with: registry)
        }
        // FCM Flavor Config
        let flavor = Bundle.main.object(forInfoDictionaryKey: "FLAVOR") as? String

        let plistName: String
        switch flavor {
        case "dev":
            plistName = "GoogleService-Info-dev"
        case nil,"","production":
            plistName = "GoogleService-Info"
        default:
            fatalError("Unknown FLAVOR")
        }

        print( Bundle.main.path(forResource: plistName, ofType: "plist"))
        guard
        let filePath = Bundle.main.path(forResource: plistName, ofType: "plist"),

        let options = FirebaseOptions(contentsOfFile: filePath)
        else {
            fatalError("Couldn't load \(plistName).plist")
        }

        FirebaseApp.configure(options: options)
        // end of FCM Flavor config

        GeneratedPluginRegistrant.register(with: self)

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }

        // 👇 Check if app was cold-started with a universal link
        if let userActivityDict = launchOptions?[.userActivityDictionary] as? [AnyHashable: Any],
        let userActivity = userActivityDict["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity,
        userActivity.activityType == NSUserActivityTypeBrowsingWeb,
        let url = userActivity.webpageURL {
            initialLink = url.absoluteString
            print("🔥 Stored cold start link: \(initialLink!)")
        }

        // 👇 Expose a method for Flutter to fetch that initial link
        if let flutterVC = window?.rootViewController as? FlutterViewController {
            let methodChannel = FlutterMethodChannel(
                name: "com.dieayaplus.user/links",
                binaryMessenger: flutterVC.binaryMessenger
            )

            methodChannel.setMethodCallHandler { [weak self] (call, result) in
                if call.method == "getInitialLink" {
                    result(self?.initialLink)
                }
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Called when the app is opened via a Universal Link (background/foreground case)
    override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
        let url = userActivity.webpageURL {
            print("🔥 Universal Link Opened: \(url)")

            if let flutterVC = window?.rootViewController as? FlutterViewController {
                let methodChannel = FlutterMethodChannel(
                    name: "com.dieayaplus.user/links",
                    binaryMessenger: flutterVC.binaryMessenger
                )
                methodChannel.invokeMethod("onLinkOpened", arguments: ["url": url.absoluteString])
            }

            return true
        }
        return false
    }
}
