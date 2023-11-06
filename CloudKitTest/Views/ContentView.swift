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
        Text("ITS SIGNED IN: \(vm.isSignedInToiCloud.description.uppercased())")
        Text(vm.error)
        Text("Permission: \(vm.permissionStatus.description.uppercased())")
        Text("Name: \(vm.userName)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
