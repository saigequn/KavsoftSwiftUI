//
//  ImageView.swift
//  PinterestGridAnimation
//
//  Created by JXW003 on 2024/5/15.
//

import SwiftUI

struct ImageView: View {
    
    var post: Item
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            if let image = post.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
            }
        }
    }
}
