import Flutter
import UIKit
import Firebase
import GoogleMaps



@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GMSServices.provideAPIKey("AIzaSyASFpQ0BJ99BZ-b19_2tGAka4sdB8E7tkE")

        FirebaseApp.configure()
        GeneratedPluginRegistrant.register(with: self)
        
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}




