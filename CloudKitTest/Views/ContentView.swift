//
//  ContentView.swift
//  CloudKitTest
//
//  Created by Guilherme Nunes Lobo on 24/08/23.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    @StateObject private var vm = CloudKitUserBootcampViewModel()
    
    var body: some View {
        // Exibe se o usuário está logado no iCloud
        Text("ITS SIGNED IN: \(vm.isSignedInToiCloud.description.uppercased())")
        
        // Exibe mensagens de erro relacionadas ao iCloud, se houverem
        Text(vm.error)
        
        // Exibe o status de permissão para o aplicativo
        Text("Permission: \(vm.permissionStatus.description.uppercased())")
        
        // Exibe o nome do usuário do iCloud
        Text("Name: \(vm.userName)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
