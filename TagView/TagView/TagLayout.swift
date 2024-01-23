//
//  TagLayout.swift
//  TagView
//
//  Created by JXW003 on 2024/1/23.
//

import SwiftUI

struct TagLayout: Layout {
    
    var alignment: Alignment = .center
    var spacing: CGFloat = 10
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var height: CGFloat = 0
        let rows = generateRows(maxWidth, proposal, subviews: subviews)
        
        for (index, row) in rows.enumerated() {
            /// Finding max Height in each row and adding it to the View's total Height
            if index == (rows.count - 1) {
                /// Since there is no spacing needed for the last item
                height += row.maxHeight(proposal)
            } else {
                height += row.maxHeight(proposal) + spacing
            }
        }
        return .init(width: maxWidth, height: height)
    }
    
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var origin = bounds.origin
        let maxWidth = bounds.width
        let rows = generateRows(maxWidth, proposal, subviews: subviews)
        
        for row in rows {
            /// Reseting Origin X to Zero for Each Row
            let leading: CGFloat = bounds.maxX - maxWidth
            let trailing = bounds.maxX - (row.reduce(CGFloat.zero) { partialResult, view in
                let width = view.sizeThatFits(proposal).width
                if view == row.last {
                    /// Mo Spacing
                    return partialResult + width
                }
                /// With Spacing
                return partialResult + width + spacing
            })
            let center = (trailing + leading) / 2
            origin.x = (alignment == .leading ? leading : alignment == .trailing ? trailing : center)
                        
            for view in row {
                let viewSize = view.sizeThatFits(proposal)
                view.place(at: origin, proposal: proposal)
                /// Updating Origin X
                origin.x += (viewSize.width + spacing)
            }
            /// Updating Origin Y
            origin.y += (row.maxHeight(proposal) + spacing)
        }
    }
    
    
    func generateRows(_ maxWidth: CGFloat, _ proposal: ProposedViewSize, subviews: Subviews) -> [[LayoutSubviews.Element]] {
        var row: [LayoutSubviews.Element] = []
        var rows: [[LayoutSubviews.Element]] = []
        
        /// Origin
        var origin = CGRect.zero.origin
        for view in subviews {
            let viewSize = view.sizeThatFits(proposal)
            
            /// Pushing to New Row
            if (origin.x + viewSize.width + spacing) > maxWidth {
                rows.append(row)
                row.removeAll()
                /// Resetting x Origin since it needs to start from left to right
                origin.x = 0
            }
            /// Adding item to same row
            row.append(view)
            /// Updating Origin X
            origin.x += (viewSize.width + spacing)
        }
        if !row.isEmpty {
            rows.append(row)
            row.removeAll()
        }
        return rows
    }
}


extension [LayoutSubviews.Element] {
    func maxHeight(_ proposal: ProposedViewSize) -> CGFloat {
        return self.compactMap { view in
            return view.sizeThatFits(proposal).height
        }.max() ?? 0
    }
}


#Preview {
    ContentView()
}
