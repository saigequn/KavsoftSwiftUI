//
//  ContentView.swift
//  CustomFileExtensions
//
//  Created by JXW003 on 2024/1/15.
//

import SwiftUI
import CryptoKit


struct ContentView: View {
    
    @State private var transactions: [Transaction] = []
    @State private var importTransactions: Bool = false

    var body: some View {
        NavigationStack {
            List(transactions) { transaction in
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(transaction.title)
                        
                        Text(transaction.date.formatted(date: .numeric, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer(minLength: 0)
                    
                    Text("$\(Int(transaction.amount))")
                        .font(.callout.bold())
                }
                 
            }
            .navigationTitle("Transactions")
            .toolbar(content: {
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "plus") {
                        transactions.append(.init())
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "square.and.arrow.down.fill") {
                        importTransactions.toggle()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    ShareLink(item: Transactions(transactions: transactions), preview: SharePreview("Share", image: "square.and.arrow.up.fill"))
                }
            })
        }
        .fileImporter(isPresented: $importTransactions, allowedContentTypes: [.trnExportType]) { result in
            switch result {
            case .success(let URL):
                do {
                    let encrypteData = try Data(contentsOf: URL)
                    let decrypteData = try AES.GCM.open(.init(combined: encrypteData), using: .trnKey)
                    let decodedTransactions = try JSONDecoder().decode(Transactions.self, from: decrypteData)
                    self.transactions = decodedTransactions.transactions
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
}
