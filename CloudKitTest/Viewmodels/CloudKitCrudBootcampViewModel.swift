//
//  CloudKitCrudBootcampViewModel.swift
//  CloudKitTest
//
//  Created by Guilherme Nunes Lobo on 06/11/23.
//

import SwiftUI
import CloudKit

class CloudKitCrudBootcampViewModel: ObservableObject {
    
    // Variáveis de estado observáveis
    @Published var text: String = ""
    @Published var fruits: [FruitModel] = []
    
    // Inicializador da classe
    init() {
        fetchItems()
    }
    
    // Função chamada quando o botão de adicionar é pressionado
    func addButtonPressed() {
        guard !text.isEmpty else { return }
        addItem(name: text)
    }
    
    // Função privada para adicionar um novo item
    private func addItem(name: String) {
        let newFruit = CKRecord(recordType: "Fruits")
        newFruit["name"] = name
        
        // Chama a função para salvar o registro
        saveItem(record: newFruit)
    }
    
    // Função para renomear uma fruta
    func renameFruit(_ fruit: FruitModel, newName: String) {
        let record = fruit.record
        record["name"] = newName
        
        // Chama a função para salvar o registro
        saveItem(record: record)
    }

    // Função para atualizar os itens (exemplo com nome "NEW NAME")
    func updateItems(fruit: FruitModel) {
        let record = fruit.record
        record["name"] = "NEW NAME"
        
        // Chama a função para salvar o registro
        saveItem(record: record)
    }
    
    // Função para deletar um item
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
    
    // Função privada para salvar um registro
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
    
    // Função privada para buscar os itens
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
