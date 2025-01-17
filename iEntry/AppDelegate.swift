//
//  AppDelegate.swift
//  iEntry
//
//  Created by ZAFAR on 04/08/2021.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Firebase

@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var reloadTimer = Timer()
    var window:UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        TokenManager.shareToken.token(email: ShareData.shareInfo.Email ?? "", password: ShareData.shareInfo.password ?? "", token: { accessToken in
            ShareData.shareInfo.token = accessToken
        })
        self.reloadTimer = Timer.scheduledTimer(withTimeInterval: 2800, repeats: true, block: { _ in
            TokenManager.shareToken.token(email: ShareData.shareInfo.Email ?? "", password: ShareData.shareInfo.password ?? "", token: { accessToken in
                ShareData.shareInfo.token = accessToken
            })
        })
        FirebaseApp.configure()
       let manager =  NotificationManager()
        manager.RegisterNotification()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        GMSPlacesClient.provideAPIKey("AIzaSyBz2BKmTH4eXG9iFzrPxocKtySr83bvIT0")
        GMSServices.provideAPIKey("AIzaSyBz2BKmTH4eXG9iFzrPxocKtySr83bvIT0")
        if let token = Messaging.messaging().fcmToken {
           print("FCM Token", token)
            ShareData.shareInfo.fcmToken = token
        }
        
        if ShareData.shareInfo.saveLanguage == "en" {
            myDefaultLanguage = .en
            
        } else if ShareData.shareInfo.saveLanguage == "fr" {
            myDefaultLanguage = .fr
        }
        else {
            myDefaultLanguage = .es
        }
        
        
        
        
        return true
    }

    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "iEntry")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        if let fcmToken = InstanceID.instanceID().token() {
//            print("InstanceID token: \(fcmToken)")
//        }
//    }
    
    
    
    
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

