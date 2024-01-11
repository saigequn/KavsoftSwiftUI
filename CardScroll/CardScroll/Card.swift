//
//  Card.swift
//  CardScroll
//
//  Created by JXW003 on 2024/1/10.
//

import SwiftUI

struct Card: Identifiable {
    var id: UUID = .init()
    var bgColor: Color
    var balance: String
}
var cards: [Card] = [
    Card(bgColor: .red,     balance: "$125,000"),
    Card(bgColor: .blue,    balance: "$25,000"),
    Card(bgColor: .orange,  balance: "$25,000"),
    Card(bgColor: .purple,  balance: "$5,000")
]



struct Expense: Identifiable {
    var id: UUID = .init()
    var amountSpent: String
    var product: String
    var spendType: String
}

var expenses: [Expense] = [
    Expense(amountSpent: "$128", product: "Amazon Purchase",     spendType: "Groceries"),
    Expense(amountSpent: "$10",  product: "Youtube Premium",     spendType: "Streaming"),
    Expense(amountSpent: "$10",  product: "Dribble",             spendType: "Membership"),
    Expense(amountSpent: "$99",  product: "Magic Keyboard",      spendType: "Products"),
    Expense(amountSpent: "$9",   product: "Pattern",             spendType: "Membership"),
    Expense(amountSpent: "$108", product: "Instagram",           spendType: "Ad Publish"),
    Expense(amountSpent: "$15",  product: "Netflix",             spendType: "Streaming"),
    Expense(amountSpent: "$348", product: "Photoshop",           spendType: "Editing"),
    Expense(amountSpent: "$99",  product: "Sigma",               spendType: "ProMember"),
    Expense(amountSpent: "$89",  product: "Magic Mouse",         spendType: "Products"),
    Expense(amountSpent: "$120", product: "Studio Display",      spendType: "Products"),
    Expense(amountSpent: "$39",  product: "Sketch Subscription", spendType: "Membership")
]
