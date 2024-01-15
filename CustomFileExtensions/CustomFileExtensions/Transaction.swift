//
//  Transaction.swift
//  CustomFileExtensions
//
//  Created by JXW003 on 2024/1/15.
//

import SwiftUI
import CoreTransferable
import UniformTypeIdentifiers
import CryptoKit


struct Transaction: Identifiable, Codable {
    var id: UUID = .init()
    var title: String
    var date: Date
    var amount: Double
    
    init() {
        self.title = "Sample Text"
        self.amount = .random(in: 5000...10000)
        let calendar = Calendar.current
        self.date = calendar.date(byAdding: .day, value: .random(in: 1...100), to: .now) ?? .now
    }
}


struct Transactions: Codable, Transferable {
    var transactions: [Transaction]
    
    static var transferRepresentation: some TransferRepresentation {
        
        DataRepresentation(exportedContentType: .trnExportType) {
            let data = try JSONEncoder().encode($0)
            guard let encrypteData = try AES.GCM.seal(data, using: .trnKey).combined else {
                throw Encryption.failed
            }
            return encrypteData
        }
        .suggestedFileName("Transactions \(Date())")
    }
    
    enum Encryption: Error {
        case failed
    }
}


extension SymmetricKey {
    static var trnKey: SymmetricKey {
        let key = "iJUSTINE".data(using: .utf8)!
        let sha256 = SHA256.hash(data: key)
        
        return .init(data: sha256)
    }
}


extension UTType {
    static var trnExportType = UTType(exportedAs: "com.jiukuaidao.demo.CustomFileExtensions.trn")
}
