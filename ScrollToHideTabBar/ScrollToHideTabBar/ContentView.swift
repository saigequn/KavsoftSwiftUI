//
//  ContentView.swift
//  ScrollToHideTabBar
//
//  Created by JXW003 on 2024/1/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var tabState: Visibility = .visible
    
    var body: some View {
        TabView {
            NavigationStack {
                TabStateScrollView(axis: .vertical, showsIndicator: false, tabState: $tabState) {
                    VStack(spacing: 15) {
                        ForEach(1...5, id:\.self) { index in
                            GeometryReader(content: { geometry in
                                let size = geometry.size
                                
                                Image("Pic\(index)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: size.width, height: size.height)
                                    .clipShape(.rect(cornerRadius: 12))
                            })
                            .frame(height: 210)
                        }
                    }
                    .padding(15)
                }
                .navigationTitle("Home")
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            Text("Favourites")
                .tabItem {
                    Image(systemName: "suit.heart")
                    Text("Favourites")
                }
            
            Text("Notifications")
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
            
            Text("Account")
                .tabItem {
                    Image(systemName: "person")
                    Text("Account")
                }
        }
    }
}

#Preview {
    ContentView()
}
