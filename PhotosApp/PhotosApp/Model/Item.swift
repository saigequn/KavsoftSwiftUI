//
//  Item.swift
//  PhotosApp
//
//  Created by JXW003 on 2024/5/14.
//

import SwiftUI


struct Item: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String
    var image: UIImage?
    var previewImage:UIImage?
    var appeared:Bool = false
}


var sampleItems: [Item] = [
    .init(title: "Fanny Hagan",                 image: UIImage(named: "Pic1")),
    .init(title: "Han-Chieh Lee",               image: UIImage(named: "Pic2")),
    .init(title: "xiaofu666",                   image: UIImage(named: "Pic3")),
    .init(title: "Abril Altamirano",            image: UIImage(named: "Pic4")),
    .init(title: "Gülsah Aydogan",              image: UIImage(named: "Pic5")),
    .init(title: "Melike Sayar Melikesayar",    image: UIImage(named: "Pic6")),
    .init(title: "Maahid Photos",               image: UIImage(named: "Pic7")),
    .init(title: "Pelageia Zelenina",           image: UIImage(named: "Pic8")),
    .init(title: "Ofir Eliav",                  image: UIImage(named: "Pic9")),
    .init(title: "Melike Sayar Melikesayar",    image: UIImage(named: "Pic 10")),
    .init(title: "Lurich Sayar Hello World",    image: UIImage(named: "Pic 11")),
    .init(title: "Han-Chieh Lee",               image: UIImage(named: "Pic 12")),
    .init(title: "Chieh",                       image: UIImage(named: "Pic 13")),
    .init(title: "Abril Altamirano",            image: UIImage(named: "Pic 14")),
    .init(title: "Gülsah Aydogan",              image: UIImage(named: "Pic 15")),
    .init(title: "Melike Sayar Melikesayar",    image: UIImage(named: "Pic 16")),
    .init(title: "Maahid Photos",               image: UIImage(named: "Pic 17")),
    .init(title: "Pelageia Zelenina",           image: UIImage(named: "Pic 18")),
    .init(title: "Ofir Eliav",                  image: UIImage(named: "Pic 19")),
]
