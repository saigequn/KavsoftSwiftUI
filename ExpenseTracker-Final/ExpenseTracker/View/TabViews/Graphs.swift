//
//  Graphs.swift
//  ExpenseTracker
//
//  Created by JXW003 on 2023/12/29.
//

import SwiftUI
import Charts
import SwiftData


struct Graphs: View {
    
    @Query(animation: .snappy) private var transactions: [Transaction]
    @State private var chartGroups: [ChartGroup] = []
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 10) {
                    ChartView()
                        .frame(height: 200)
                        .padding(10)
                        .padding(.top, 10)
                        .background(.background, in: .rect(cornerRadius: 10))
                    
                    ForEach(chartGroups) { group in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(format(date: group.date, format: "MMM yy"))
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            NavigationLink {
                                ListOfExepenseView(month: group.date)
                            } label: {
                                CardView(income: group.totalIncome, expense: group.totalExpense)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(15)
            }
            .navigationTitle("Graphs")
            .background(.gray.opacity(0.15))
            .onAppear {
                createChartGroup()
            }
        }
    }
    
    
    private func createChartGroup() {
        Task.detached(priority: .high) {
            let calendar = Calendar.current
            let groupedByDate = Dictionary(grouping: transactions) { transaction in
                let compoenents = calendar.dateComponents([.month, .year], from: transaction.dateAdded)
                return compoenents
            }
            
            let sortedGroups = groupedByDate.sorted {
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedAscending
            }
            
            let chartGroups = sortedGroups.compactMap { dict -> ChartGroup? in
                let date = calendar.date(from: dict.key) ?? .init()
                
                let income = dict.value.filter({ $0.category == Category.income.rawValue })
                let incomeTotalValue = total(income, category: .income)
                
                let expense = dict.value.filter({ $0.category == Category.expense.rawValue })
                let expenseTotalValue = total(expense, category: .expense)
                
                return .init(date: date,
                             categories: [
                                .init(totalValue: incomeTotalValue, category: .income),
                                .init(totalValue: expenseTotalValue, category: .expense)
                             ],
                             totalIncome: incomeTotalValue,
                             totalExpense: expenseTotalValue)
            }
            
            await MainActor.run {
                self.chartGroups = chartGroups
            }
        }
    }
    
    
    @ViewBuilder
    func ChartView() -> some View {
        Chart {
            ForEach(chartGroups) { group in
                ForEach(group.categories) { chart in
                    
                    BarMark(
                        x: .value("Month", format(date: group.date, format: "MMM yy")),
                        y: .value(chart.category.rawValue, chart.totalValue),
                        width: 20)
                    .position(by: .value("Category", chart.category.rawValue), axis: .horizontal)
                    .foregroundStyle(by: .value("Category", chart.category.rawValue))

                }
            }
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 4)
        .chartLegend(position: .bottom, alignment: .trailing)
        .chartYAxis {
            AxisMarks(position: .leading) {value in
                let doubleValue = value.as(Double.self) ?? 0
                                
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    Text(axisLabel(doubleValue))
                    
                }
            }
        }
        .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient])
    }
    
    
    func axisLabel(_ value: Double) -> String {
        let intValue = Int(value)
        let kValue = intValue / 1000
        return intValue < 1000 ? "\(intValue)" : "\(kValue)k"
    }
    
}

#Preview {
    Graphs()
}
