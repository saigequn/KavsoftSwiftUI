//
//  ListOfExepenseView.swift
//  ExpenseTracker
//
//  Created by JXW003 on 2024/1/3.
//

import SwiftUI

struct ListOfExepenseView: View {
    
    let month: Date
        
    var body: some View {
        
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                Section {
                    FilterTransactionsView(startDate: month.startOfMonth, endDate: month.endOfMonth, category: .income) { transactions in
                        ForEach(transactions) { transaction in
//                            NavigationLink(value: transaction) {
//                                TransactionCardView(transaction: transaction)
//                            }
//                            .buttonStyle(.plain)
                            NavigationLink {
                                TransactionView(editTransaction: transaction)
                            } label: {
                                TransactionCardView(transaction: transaction)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } header: {
                    Text("Income")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Section {
                    FilterTransactionsView(startDate: month.startOfMonth, endDate: month.endOfMonth, category: .expense) { transactions in
                        ForEach(transactions) { transaction in
//                            NavigationLink(value: transaction) {
//                                TransactionCardView(transaction: transaction)
//                            }
//                            .buttonStyle(.plain)
                            NavigationLink {
                                TransactionView(editTransaction: transaction)
                            } label: {
                                TransactionCardView(transaction: transaction)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } header: {
                    Text("Expense")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

            }
            .padding(15)
        }
        .background(.gray.opacity(0.15))
        .navigationTitle(format(date: month, format: "MMM yy"))
//        .navigationDestination(for: Transaction.self) { transaction in
//            TransactionView(editTransaction: transaction)
//        }
    }
}

//#Preview {
//    ListOfExepenseView(month: .now)
//}
