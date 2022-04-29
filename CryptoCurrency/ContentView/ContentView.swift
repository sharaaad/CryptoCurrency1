//
//  ContentView.swift
//  CryptoCurrency
//
//  Created by admin on 26/04/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ContentViewModel(networkManager:CryptoAPI())
    
    var body: some View {
        NavigationView {
            VStack{
                VStack {
                    Stepper(NSLocalizedString("Amount: ", comment: "Replacing section of text") + "\(Int(vm.amount))€", value: $vm.amount, step: 100)
                    Slider(value: $vm.amount, in: 1...10_000)
                    
                }
                .padding()
                
                List(vm.filteredRates) { item in HStack() {
                    Text(item.assetIdQuote ?? "")
                        .bold()
                    Spacer()
                    Text("\(vm.calculateRate(rate: item), specifier: "%.2f")")
                }
                    
                }
                .listStyle(.plain)
                .searchable(text: $vm.searchText)
                
            }
            .onAppear(perform: vm.refreshData)
            .navigationTitle("Crypto")
            .toolbar {
                ToolbarItem {
                    Button("Refresh", action: vm.refreshData)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
