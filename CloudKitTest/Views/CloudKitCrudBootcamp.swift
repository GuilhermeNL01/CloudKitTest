//
//  CloudKitCrudBootcamp.swift
//  CloudKitTest
//
//  Created by Guilherme Nunes Lobo on 01/11/23.
//

import SwiftUI
import CloudKit

struct CloudKitCrudBootcamp: View {
    @StateObject private var vm = CloudKitCrudBootcampViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                // Cabeçalho da tela
                header
                // Campo de texto para adicionar itens
                textField
                // Botão para adicionar itens
                addButton
                List {
                    ForEach(vm.fruits, id: \.self) { fruit in
                        HStack {
                            Text(fruit.name)
                        }
                        .swipeActions {
                            Button(action: {
                                // Exibir um alerta para obter o novo nome da fruta
                                let alert = UIAlertController(title: "Rename Fruit", message: "Enter the new name for the fruit", preferredStyle: .alert)
                                alert.addTextField { textField in
                                    textField.placeholder = "New Name"
                                }
                                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                                alert.addAction(UIAlertAction(title: "Rename", style: .default) { _ in
                                    if let newName = alert.textFields?.first?.text {
                                        // Atualizar a fruta com o novo nome
                                        vm.renameFruit(fruit, newName: newName)
                                    }
                                })

                                // Apresentar o alerta na tela
                                if let viewController = UIApplication.shared.windows.first?.rootViewController {
                                    viewController.present(alert, animated: true, completion: nil)
                                }
                            }) {
                                Label("Rename", systemImage: "pencil")
                            }
                            .tint(.blue)

                            Button(action: {
                                // Remover a fruta
                                vm.deleteItem(indexSet: IndexSet([vm.fruits.firstIndex(of: fruit)!]))
                            }) {
                                Label("Remove", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                    .onDelete(perform: vm.deleteItem)
                }
                .listStyle(.plain)
                
                // Botão para fechar a tela
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                }
            }
            .onTapGesture {
                // Ocultar o teclado ao tocar fora do campo de texto
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
            })
        }
    }
}
#Preview{
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
