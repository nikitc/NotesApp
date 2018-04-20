//
//  SaveNoteListOperation.swift
//  Notes
//
//  Created by Admin on 14.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import Foundation

class SaveNoteOperation : Operation, NoteListable {
    private let fileNotebook: FileNotebook
    
    private(set) var notes: [Note] = []
    private let note: Note
    
    init(fileNotebook: FileNotebook, note: Note) {
        self.fileNotebook = fileNotebook
        self.note = note
    }
    
    override func main() {
        fileNotebook.add(note: note)
        fileNotebook.saveAllNotes()
    }
}
