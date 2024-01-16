//
//  ContentView.swift
//  InAppNotifications
//
//  Created by JXW003 on 2024/1/16.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Button("Show Sheet") {
                    showSheet.toggle()
                }
                .sheet(isPresented: $showSheet, content: {
                    
                    Button("Show AirDrop Notification") {
                        UIApplication.shared.inAppNotification(adaptForDynamicIsland: false, timeout: 5, swipeToClose: true, content: {
                            
                            HStack {
                                Image(systemName: "wifi")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("AirDrop")
                                        .font(.caption.bold())
                                        .foregroundStyle(.white)
                                    
                                    Text("From iJustine")
                                        .textScale(.secondary)
                                        .foregroundStyle(.gray)
                                }
                                .padding(.top, 20)
                                
                                Spacer(minLength: 0)
                                
                            }
                            .padding(15)
                            .background() {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(.black)
                            }
                        })
                    }
                    
                })
                
                Button("Show Notification") {
                    UIApplication.shared.inAppNotification(adaptForDynamicIsland: true, timeout: 5, swipeToClose: true, content: {
                        
                        HStack {
                            Image("Pic")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(.circle)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("iJustine")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                                
                                Text("Hello, This is iJustine")
                                    .textScale(.secondary)
                                    .foregroundStyle(.gray)
                            }
                            .padding(.top, 20)
                            
                            Spacer(minLength: 0)
                            
                            Button(action: {}, label: {
                                Image(systemName: "speaker.slash.fill")
                                    .font(.title2)
                            })
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.circle)
                            .tint(.white)
                        }
                        .padding(15)
                        .background() {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(.black)
                        }
                    })
                }
            }
            .navigationTitle("In App Notification's")
        }
    }
}

#Preview {
    ContentView()
}
