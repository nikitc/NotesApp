//
//  GetNoteByIdOperation.swift
//  Notes
//
//  Created by user on 16.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import Foundation

class GetNoteByIdOperation : Operation, NoteListable {
    private let fileNotebook: FileNotebook
    
    private(set) var notes: [Note] = []
    public var note: Note?
    private var index: Int
    
    init(fileNotebook: FileNotebook, index: Int) {
        self.fileNotebook = fileNotebook
        self.index = index
    }
    
    override func main() {
        note = fileNotebook.notes[index]
    }
}
