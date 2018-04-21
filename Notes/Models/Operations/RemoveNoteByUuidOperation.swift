//
//  RemoveNoteByUuidOperation.swift
//  Notes
//
//  Created by Admin on 14.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import Foundation

class RemoveNoteByUuidOperation : Operation, NoteListable {
    private let fileNotebook: FileNotebook
    
    private(set) var notes: [Note] = []
    private let uuid: String
    
    init(fileNotebook: FileNotebook, uuid: String) {
        self.fileNotebook = fileNotebook
        self.uuid = uuid
    }
    
    override func main() {
        fileNotebook.deleteNoteByUUID(uuid: self.uuid)
    }
}
