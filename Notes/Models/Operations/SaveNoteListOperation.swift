//
//  SaveNoteListOperation.swift
//  Notes
//
//  Created by Admin on 20.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import Foundation

class SaveNoteListOperation : Operation, NoteListable {
    private let fileNotebook: FileNotebook
    internal let notes: [Note]
    
    init(fileNotebook: FileNotebook, notes: [Note]) {
        self.fileNotebook = fileNotebook
        self.notes = notes
    }
    
    override func main() {
        for note in notes {
            fileNotebook.add(note: note)
        }
        fileNotebook.saveAllNotes()
    }
}
