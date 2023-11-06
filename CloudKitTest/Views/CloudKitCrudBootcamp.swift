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
