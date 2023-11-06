//
//  CloudKitCrudBootcampViewModel.swift
//  CloudKitTest
//
//  Created by Guilherme Nunes Lobo on 06/11/23.
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
