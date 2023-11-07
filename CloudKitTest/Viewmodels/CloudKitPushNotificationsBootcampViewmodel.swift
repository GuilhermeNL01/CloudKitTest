//
//  CloudKitPushNotificationsBootcampViewmodel.swift
//  CloudKitTest
//
//  Created by Guilherme Nunes Lobo on 07/11/23.
//

import SwiftUI
import CloudKit

class CloudKitPushNotificationsBootcampViewmodel: ObservableObject {
    
    // Função para solicitar permissões de notificações
    func requestNotificationsPermissions() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print(error)
            } else if success {
                print("Notifications Permission Success 👍")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notifications Permission Failure 👎")
            }
        }
    }
    
    // Função para cancelar a inscrição em notificações
    func unsubscribeToNotifications() {
        // CKContainer.default().publicCloudDatabase.fetchAllSubscriptions(completionHandler: )
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "fruit_added_to_database") { returnedID, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Succesfully Unsubscribed to Notifications 🐷")
            }
        }
    }
    
    // Função para se inscrever em notificações
    func subscribeToNotifications() {
        let predicate = NSPredicate(value: true)
        
        // Cria uma assinatura para notificações
        let subscription = CKQuerySubscription(recordType: "Fruits", predicate: predicate, subscriptionID: "fruit_added_to_database", options: .firesOnRecordCreation)
        
        // Configura as informações de notificação
        let notification = CKSubscription.NotificationInfo()
        notification.title = "There's a new Fruit! 🍎"
        notification.alertBody = "Open the app to check your new Fruit"
        notification.soundName = "default"
         
        subscription.notificationInfo = notification
        
        // Salva a assinatura
        CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Succesfully Subscribed to Notifications 🐰")
            }
        }
    }
}
