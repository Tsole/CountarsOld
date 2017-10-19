//
//  AppDelegate.swift
//  InsanelySImpleTracker
//
//  Created by Tsole on 13/1/17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //MARK: Realm Migration block
        let config = Realm.Configuration(
            schemaVersion: 12,
            migrationBlock: { migration, oldSchemaVersion in
                
                if (oldSchemaVersion < 7) {
                    migration.enumerateObjects(ofType: Counter.className()) { oldObject, newObject in
                        newObject!["step"] = 1
                    }
                }
                
                if (oldSchemaVersion < 9) {
                    migration.enumerateObjects(ofType: Counter.className()) { oldObject, newObject in
                        newObject!["historyEntries"] = []
                    }
                }
                
                if (oldSchemaVersion < 10) {
                    migration.enumerateObjects(ofType: Counter.className()) { oldObject, newObject in
                        newObject!["repeatIntervall"] = 0
                    }
                }
                
                if (oldSchemaVersion < 12) {
                    migration.enumerateObjects(ofType: Counter.className()) { oldObject, newObject in
                        newObject!["hasReminder"] = false
                        newObject!["reminderDate"] = nil
                    }
                }
                
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
            if !accepted {
                debugPrint("Notification access denied.")
            }
        }
        
        let openCounterAction = UNNotificationAction(identifier: "openCounter", title: "Edit Counter", options: [.foreground])
        let resetAction = UNNotificationAction(identifier: "resetCounter", title: "Reset Counter", options: [.destructive])
        
        let category = UNNotificationCategory(identifier: "myCategory", actions: [openCounterAction, resetAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        return true
    }
    
    
    func scheduleNotification(at date: Date, counter: Counter) {
        
        UNUserNotificationCenter.current().delegate = self
        
        //create a trigger
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: true)
        
        //create the content
        let content = UNMutableNotificationContent()
        content.title = counter.counterName
        content.body = "The current value of: " + counter.counterName + " is " + String(describing: counter.count) + ". Do you want to update its value or reset it ?"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "myCategory"
        
        //request to show usernotification
        let request = UNNotificationRequest(identifier: counter.counterID, content: content, trigger: trigger)
        
        //add the request in the userNotificationCenter
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [counter.counterName])
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "resetCounter" {
            debugPrint(response.notification)
            let realm = try! Realm()
            var counterToReset = realm.object(ofType: Counter.self, forPrimaryKey: response.notification.request.identifier)
            if counterToReset != nil {
                CountersManager.sharedInstance.resetCounter(counter: &counterToReset!, completionHandler: {
                })
            } else {
                return
            }
        }
        
        if response.actionIdentifier == "openCounter" {
            debugPrint(response.notification)
            let realm = try! Realm()
            let counterToOpen = realm.object(ofType: Counter.self, forPrimaryKey: response.notification.request.identifier)
            let sb = UIStoryboard(name: "CounterDetails", bundle: nil)
            let counterDetailsVC = sb.instantiateViewController(withIdentifier: "CounterDetails") as! CounterDetailViewController
            counterDetailsVC.launchedFromNotification = true
            let navController = UINavigationController(rootViewController: counterDetailsVC)
            counterDetailsVC.counter = counterToOpen
            window?.rootViewController = navController
        }
        
        completionHandler()
    }
    
    //necessary to display the notification inside the App
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.alert)
    }
}


