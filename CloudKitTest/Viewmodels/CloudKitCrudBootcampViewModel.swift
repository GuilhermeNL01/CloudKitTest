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
    @Published var fruits: [FruitModel] = [] // Atualize o tipo da propriedade para [FruitModel]
    
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
    
    func updateItems(fruit: FruitModel) {
        let record = fruit.record
        record["name"] = "NEW NAME"
        saveItem(record: record)
    }
    
    func deleteItem(indexSet: IndexSet) {
    
        guard let index = indexSet.first else { return }
        let fruit = fruits[index]
        let record = fruit.record
        
        CKContainer.default().publicCloudDatabase.delete(withRecordID: record.recordID) { [weak self] returnedRecordID, returnedError in
            DispatchQueue.main.async {
                self?.fruits.remove(at: index)

            }
        }
        
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
                let fetchedFruits = records.map { FruitModel(name: $0["name"] as? String ?? "", record: $0) }
                DispatchQueue.main.async {
                    self.fruits = fetchedFruits
                }
            }
        }
    }
}
