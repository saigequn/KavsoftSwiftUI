//
//  TripCard.swift
//  ParallaxCarousel
//
//  Created by JXW003 on 2024/1/22.
//

import SwiftUI

// Trip Card Model
struct TripCard: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var subTitle: String
    var image: String
}

var tripCards: [TripCard] = [
    .init(title: "London",   subTitle: "England",        image: "Pic1"),
    .init(title: "New York", subTitle: "USA",            image: "Pic2"),
    .init(title: "Prague",   subTitle: "Czech Republic", image: "Pic3"),
    .init(title: "Huawei",   subTitle: "Czech Republic", image: "Pic4"),
    .init(title: "Baidu",   subTitle: "Czech Republic", image: "Pic5")
]
