//
//  Transaction.swift
//  ExpenseTracker
//
//  Created by JXW003 on 2023/12/29.
//

import SwiftUI
import SwiftData

@Model
class Transaction {
    /// Properties
    var title: String
    var remarks: String
    var amount: Double
    var dateAdded: Date
    var category: String
    var tintColor: String
    
    init(title: String, remarks: String, amount: Double, dateAdded: Date, category: Category, tintColor: TintColor) {
        self.title = title
        self.remarks = remarks
        self.amount = amount
        self.dateAdded = dateAdded
        self.category = category.rawValue
        self.tintColor = tintColor.color
    }
    
    /// Extracting Color Value from tintColor String
    @Transient
    var color: Color {
        return tints.first(where: { $0.color == tintColor})?.value ?? appTint
    }
    
    @Transient
    var tint: TintColor? {
        return tints.first(where: { $0.color == tintColor })
    }
    
    @Transient
    var rawCategory: Category? {
        return Category.allCases.first(where: { category == $0.rawValue })
    }
}



var sampleTransactions: [Transaction] = [
    .init(title: "Magic Keyboard", remarks: "Apple Product", amount: 129, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
    .init(title: "Apple Music", remarks: "Subscription", amount: 10.99, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
    .init(title: "iClound+", remarks: "Subscription", amount: 0.99, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
    .init(title: "Payment", remarks: "Payment Received!", amount: 2499, dateAdded: .now, category: .income, tintColor: tints.randomElement()!),
]

