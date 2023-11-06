//
//  CloudKitCrudBootcamp.swift
//  CloudKitTest
//
//  Created by Guilherme Nunes Lobo on 01/11/23.
//

import SwiftUI
import CloudKit

class CloudKitCrudBootcampViewModel: ObservableObject {
    
    @Published var text: String = ""
    @Published var fruits: [String] = []
    
    init() {
        fetchItems()
    }
    
    func addButtonPressed() {
        guard !text.isEmpty else { return }
        addItem(name: text)
    }
    
    private func addItem(name: String) {
        let newFruit = CKRecord(recordType: "Fruits")
        newFruit["name"] = name
        saveItem(record: newFruit)
    }
    
    private func saveItem(record: CKRecord) {
        CKContainer.default().publicCloudDatabase.save(record) { _, error in
            if let error = error {
                print("Error saving record: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.text = ""
                    self.fetchItems() // Recarregar a lista após a adição
                }
            }
        }
    }
    
    private func fetchItems() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Fruits", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("Error fetching records: \(error)")
            } else if let records = records {
                let fetchedFruits = records.compactMap { $0["name"] as? String }
                DispatchQueue.main.async {
                    self.fruits = fetchedFruits
                }
            }
        }
    }
}

struct CloudKitCrudBootcamp: View {
    @StateObject private var vm = CloudKitCrudBootcampViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                header
                textField
                addButton
                List{
                    ForEach(vm.fruits,id: \.self) {
                        Text($0)
                    }

                }
                .listStyle(.plain)
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    CloudKitCrudBootcamp()
}

extension CloudKitCrudBootcamp {
    private var header: some View {
        Text("CloudKit CRUD ☁️")
            .font(.headline)
            .underline()
        
    }
    private var textField: some View {
        TextField("Add Something Here...", text: $vm.text)
            .frame(height: 55)
            .padding(.leading)
            .background(Color.gray.opacity(0.4))
            .cornerRadius(10)
    }
    private var addButton: some View {
        Button(action: {
            vm.addButtonPressed()
        }, label: {
            Text("Add")
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.pink)
                .cornerRadius(10)
        })
    }
}
