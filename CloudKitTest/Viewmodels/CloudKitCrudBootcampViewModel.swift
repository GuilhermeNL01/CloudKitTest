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
    @Published var fruits: [FruitModel] = []
    
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
        
        guard let image = UIImage(named: "imagemkk"),
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("imagemkk.jpeg"),
            let data = image.jpegData(compressionQuality: 1.0) else { return }
        
        do {
            try data.write(to: url)
            let asset = CKAsset(fileURL: url)
            newFruit["image"] = asset
            saveItem(record: newFruit)
        } catch let error {
            print(error)
        }
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
                    self.fetchItems()
                }
            }
        }
    }
    
    private func fetchItems() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Fruits", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { [weak self] records, error in
            if let error = error {
                print("Error fetching records: \(error)")
            } else if let records = records {
                let fetchedFruits = records.compactMap { record in
                    guard let name = record["name"] as? String else { return nil }
                    let imageURL = (record["image"] as? CKAsset)?.fileURL
                    return FruitModel(name: name, record: record, imageURL: imageURL)
                }

                DispatchQueue.main.async {
                    self?.fruits = fetchedFruits
                }
            }
        }
    }
}
