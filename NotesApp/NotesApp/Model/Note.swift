//
//  Note.swift
//  NotesApp
//
//  Created by JXW003 on 2024/1/11.
//

import SwiftUI
import SwiftData


@Model
class Note {
    var content: String
    var category: NoteCategory?
    var isFavourite: Bool = false
    
    init(content: String, category: NoteCategory? = nil) {
        self.content = content
        self.category = category
    }
}



@Model
class NoteCategory {
    var categoryTitle: String
    
    @Relationship(deleteRule: .cascade, inverse: \Note.category)
    var notes: [Note]?
    
    init(categoryTitle: String) {
        self.categoryTitle = categoryTitle
    }
}
