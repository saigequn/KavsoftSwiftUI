//
//  Item.swift
//  PinterestGridAnimation
//
//  Created by JXW003 on 2024/5/15.
//

import SwiftUI

struct Item: Identifiable, Hashable {
    private(set) var id: UUID = .init()
    var title: String
    var image: UIImage?
}

var sampleImages: [Item] = [
    .init(title: "Abril Altamirano", image: UIImage(named: "Pic1")),
    .init(title: "Gülsah Aydogan", image:UIImage(named : "Pic2")),
    .init(title: "Melike Sayar Melikesayar", image: UIImage(named: "Pic3")),
    .init(title: "Maahid Photos", image:UIImage(named: "Pic4")),
    .init(title: "Pelageia Zelenina", image:UIImage(named: "Pic5")),
    .init(title: "Ofir Eliav", image:UIImage(named: "Pic6")),
    .init(title: "Melike Sayar Melikesayar", image: UIImage(named:"Pic7")),
    .init(title: "Melike Sayar Melikesayar", image: UIImage(named:"Pic8")),
    .init(title: "Melike Sayar Melikesayar", image: UIImage(named:"Pic9")),
    .init(title: "Erik Mclean", image:UIImage(named: "Pic10")),
    .init(title: "Fatma DELIASLAN", image:UIImage(named: "Pic11")),
]
