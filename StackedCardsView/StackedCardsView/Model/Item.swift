//
//  Item.swift
//  StackedCardsView
//
//  Created by JXW003 on 2024/5/17.
//

import SwiftUI

struct Item: Identifiable {
    var id: UUID = .init()
    var logo: String
    var title: String
    var description: String = "Lorem Ipsum is simple dummy text of the printing and typesetting industry"
}

var items: [Item] = [
    Item(logo: "", title: ""),
    Item(logo: "Amazon", title: "Amazon"),
    Item(logo: "Youtube", title: "Youtube"),
    Item(logo: "Dribble", title: "Dribble"),
    Item(logo: "Apple", title: "Apple"),
    Item(logo: "", title: "Patreon"),
    Item(logo: "", title: "Instagram"),
    Item(logo: "", title: "Netflix"),
    Item(logo: "", title: "Photoshop"),
    Item(logo: "", title: "Figma")
]

