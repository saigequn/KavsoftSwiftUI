//
//  NotesAppApp.swift
//  NotesApp
//
//  Created by JXW003 on 2024/1/11.
//

import SwiftUI

@main
struct NotesAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 320, minHeight: 400)
        }
        .windowResizability(.contentSize)
        /// adding Data Model to the app
        .modelContainer(for: [Note.self, NoteCategory.self])
    }
}
