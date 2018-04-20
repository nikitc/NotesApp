//
//  UpdateNoteOperation.swift
//  Notes
//
//  Created by Admin on 15.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import Foundation

class UpdateNoteOperation : Operation, NoteListable {
    private let fileNotebook: FileNotebook
    
    private(set) var notes: [Note] = []
    private let note: Note
    private var index: Int
    
    init(fileNotebook: FileNotebook, note: Note, index: Int) {
        self.fileNotebook = fileNotebook
        self.note = note
        self.index = index
    }
    
    override func main() {
        fileNotebook.updateNote(note: note, index: index)
        fileNotebook.saveAllNotes()
    }
}
