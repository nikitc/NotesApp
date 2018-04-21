//
//  GetNoteByIdOperation.swift
//  Notes
//
//  Created by user on 16.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import Foundation

class GetNoteByUUIDOperation : Operation, NoteListable {
    private let fileNotebook: FileNotebook    
    private(set) var notes: [Note] = []
    public var note: Note?
    private var uuid: String
    
    init(fileNotebook: FileNotebook, uuid: String) {
        self.fileNotebook = fileNotebook
        self.uuid = uuid
    }
    
    override func main() {
        note = fileNotebook.getNoteByUUID(uuid: self.uuid)
    }
}
