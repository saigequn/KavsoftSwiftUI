//
//  Post.swift
//  ComplexHeroAnimation
//
//  Created by JXW003 on 2024/1/4.
//

import SwiftUI

struct Post: Identifiable {
    let id: UUID = .init()
    var username: String
    var content: String
    var pics: [PicItem]
    var scrollPosition: UUID?
}

var samplePosts: [Post] = [
    .init(username: "iJustine", content: "Nature Pics", pics: pics),
    .init(username: "iJustineeeee", content: "Nature Picssss", pics: pics2)
]

private var pics: [PicItem] = (1...5).compactMap { index -> PicItem? in
    return .init(image: "pic\(index)")
}

private var pics2: [PicItem] = (1...5).reversed().compactMap { index -> PicItem? in
    return .init(image: "pic\(index)")
}
