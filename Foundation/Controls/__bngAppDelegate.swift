//
//  __bngAppDelegate.swift
//  example
//
//  Copyright © 2019 Bong. All rights reserved.
//

import Foundation
import Bong
import Firebase
//import FBSDKLoginKit

class __bngAppDelegate : _bngAppDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    private let fcmMessageIDKey = "gcm.message_id"
    public func onToken(token:String?) {}
    public func onPush(from:Int, data:NSDictionary?){}
    public func onReady(token:String?) {}
    
    func onLaunch(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?, fcm:Bool) {
        super.onLaunch(application, launchOptions: launchOptions)
        
        if fcm {
            FirebaseApp.configure()
            Messaging.messaging().delegate = self
            // iOS 10 support
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
            application.registerForRemoteNotifications()
        }
        //ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        onReady(token: deviceTokenString)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[fcmMessageIDKey] {
            //_bngLog.d("Message ID: \(messageID)")
            completionHandler([.alert, .badge, .sound])
            onPush(from:1, data: userInfo as NSDictionary)
        }
        //_bngLog.d(userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo as NSDictionary
        if let messageID = userInfo[fcmMessageIDKey] {
            onPush(from:0, data: userInfo)
        }
        //_bngLog.d(userInfo)
        completionHandler()
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        onToken(token: fcmToken)
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        _bngLog.d("Received data message: \(remoteMessage.appData)")
    }
    override func onSource(_ application: UIApplication, url: URL, sourceApplication: String?, annotation: Any) {
        super.onSource(application, url: url, sourceApplication: sourceApplication, annotation: annotation)
        guard let scheme = url.scheme else { return }
        if scheme.contains("fb") {
            //ApplicationDelegate.shared.application(application, open: url.absoluteURL, sourceApplication: sourceApplication, annotation: annotation)
        }
        else {
            //if KOSession.isKakaoAccountLoginCallback(url) {
            //    KOSession.handleOpen(url)
            //}
        }
    }
    override func onOpenUrl(_ application: UIApplication, url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) {
        super.onOpenUrl(application, url: url)
        guard let scheme = url.scheme else { return }
        if #available(iOS 9.0, *) {
            let sourceApplication: String? = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
            if scheme.contains("fb") {
                //ApplicationDelegate.shared.application(application, open: url.absoluteURL, sourceApplication: sourceApplication, annotation: nil)
            }
            else if scheme.contains("kakao") {
                //if KOSession.handleOpen(url) {
                //}
            }
        }
    }
}
