//
//  AppDelegate.swift
//  Sample
//
//  Created by jagdish on 19/07/20.
//  Copyright © 2020 Jagdish Mer. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SideMenuSwift
import CryptoKit
import GoogleMaps
import CoreData
import Firebase
import FirebaseMessaging
import FirebaseAnalytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {

    var window: UIWindow?
    var userType: String?
    var deviceToken: String?
    var isEdit: Bool = false
    var memberId: String = ""
    var dicMember : [String: Any] = [:]
    var dicDataProfile: [[String : Any]]?
    var dicMemberProfile: [[String : Any]]?
    var ProfileDataModel: ProfileDataModel?
    var ProfileMemberModel: ProfileMemberModel?
    var dicOnteTimeGuruDakshina : [String: Any] = [:]
    
    

//    // Add this property to the AppDelegate class, swiftUI coredata usage 
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "YourDataModelName")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true

        GMSServices.provideAPIKey("AIzaSyD6uQGZjDaPzr1L51e_njLKaqYYtVYJDxk")

        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)

        // 1
        UNUserNotificationCenter.current().delegate = self
        // 2
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions) { _, _ in }
        // 3
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self

		if #available(iOS 13.0, *) {
			window?.overrideUserInterfaceStyle = .light
		} else {
			// Fallback on earlier versions
		}

        configureSideMenu()

        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "LaunchVC",
            AnalyticsParameterItemName: "LaunchVC"
        ])
		return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      Messaging.messaging().apnsToken = deviceToken
        print("deviceToken::: \(deviceToken)")
    }

    private func configureSideMenu() {
        SideMenuController.preferences.basic.menuWidth = (UIScreen.main.bounds.width * 0.8) // 80% of screen
        SideMenuController.preferences.basic.defaultCacheKey = "0"
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        let config = UISceneConfiguration(name: "Default Configuration", sessionRole: .windowApplication)
        config.sceneClass = UIWindowScene.self
        config.delegateClass = SceneDelegate.self
        if UIDevice.current.userInterfaceIdiom == .phone {
            config.storyboard = UIStoryboard(name: "Main", bundle: nil)
        } else {
            config.storyboard = UIStoryboard(name: "Main", bundle: nil)
//            config.storyboard = UIStoryboard(name: "Main_ipad", bundle: nil)
        }

        return config
    }
}

#if DEBUG
extension AppDelegate {
    private func setupTestingEnvironment(with arguments: [String]) {
        if arguments.contains("SwitchToRight") {
            SideMenuController.preferences.basic.direction = .left
        }
    }
}
#endif

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler:
    @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if #available(iOS 14.0, *) {
        completionHandler([[.banner, .sound]])
    } else {
        // Fallback on earlier versions
    }
  }

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    completionHandler()
  }
}

extension AppDelegate: MessagingDelegate {
  func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) {
    let tokenDict = ["token": fcmToken ?? ""]
    print("fcmToken::: \(fcmToken ?? "")")
      deviceToken = fcmToken ?? ""
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: tokenDict)
  }
}
