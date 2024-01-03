//
//  ChartModal.swift
//  ExpenseTracker
//
//  Created by JXW003 on 2024/1/3.
//

import SwiftUI

struct ChartGroup: Identifiable {
    let id: UUID = .init()
    var date: Date
    var categories: [ChartCategory]
    var totalIncome: Double
    var totalExpense: Double
}


struct ChartCategory: Identifiable {
    let id: UUID = .init()
    var totalValue: Double
    var category: Category
}

