//
//  CloudKitPushNotificationBootcamp.swift
//  CloudKitTest
//
//  Created by Guilherme Nunes Lobo on 07/11/23.
//

import SwiftUI

struct CloudKitPushNotificationBootcamp: View {
    
    @StateObject private var vm = CloudKitPushNotificationsBootcampViewmodel()
    @State private var isPresentingCrudView = false

    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                // Botão para solicitar permissões de notificações
                Button("Request Notifications Permission") {
                    vm.requestNotificationsPermissions()
                }

                // Botão para se inscrever em notificações
                Button("Subscribe to Notifications") {
                    vm.subscribeToNotifications()
                }

                // Botão para cancelar a inscrição em notificações
                Button("Unsubscribe to Notifications") {
                    vm.unsubscribeToNotifications()
                }

                // Navegar para a tela CloudKitCrudBootcamp
                NavigationLink(destination: CloudKitCrudBootcamp(), isActive: $isPresentingCrudView) {
                    EmptyView()
                }

                Button("Ir para CloudKitCrudBootcamp") {
                    isPresentingCrudView = true
                }
            }
            .navigationBarTitle("Push Notification ")
        }
    }
}

#Preview {
    CloudKitPushNotificationBootcamp()
}
