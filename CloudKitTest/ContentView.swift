//
//  ContentView.swift
//  CloudKitTest
//
//  Created by Guilherme Nunes Lobo on 24/08/23.
//

import SwiftUI
import CloudKit

class CloudKitUserBootcampViewModel: ObservableObject {
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var userName: String = ""
    @Published var permissionStatus: Bool = false
    
    init() {
        getiCloudStatus()
        requestPermission()
        fetchiCloudUserRecordID()
    }
    
    private func getiCloudStatus() {
        CKContainer.default().accountStatus {[weak self] returnedStatus, returnedError in
            DispatchQueue.main.async {
                switch returnedStatus {
                case.available:
                    self?.isSignedInToiCloud = true
                case.noAccount:
                    self?.error = CloudKitError.iCloudAccountNotFound.localizedDescription
                case.couldNotDetermine:
                    self?.error = CloudKitError.iCloudAccountNotDetermined.localizedDescription
                case .restricted:
                    self?.error = CloudKitError.iCloudAccountRestricted.localizedDescription
                default:
                    self?.error = CloudKitError.iCloudAccountUnknown.localizedDescription
                    
                }
            }
        }
    }
    enum CloudKitError: String, LocalizedError {
        case iCloudAccountNotFound
        case iCloudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnknown
        
    }
    func requestPermission() {
        CKContainer.default().requestApplicationPermission(.userDiscoverability) {[weak self] returnedStatus, returnedError in
            DispatchQueue.main.async {
                if returnedStatus == .granted {
                    self?.permissionStatus = true
                }
            }
        }
    }
    func fetchiCloudUserRecordID() {
        CKContainer.default().fetchUserRecordID {[weak self] returnedID, returnedError in
            if let id = returnedID {
                self?.discoveriCloudUser(id: id)
            }
        }
    }
    func discoveriCloudUser(id: CKRecord.ID) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) {[weak self] returnedIdentity, returnedError in
            DispatchQueue.main.async {
                if let name = returnedIdentity?.nameComponents?.givenName {
                    self?.userName = name
                }
            }
        }
    }
}




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
