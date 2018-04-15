//
//  GetNoteListOperation.swift
//  Notes
//
//  Created by Admin on 14.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import Foundation
import UIKit

class GetNoteListOperation : Operation, NoteListable {
    private let fileNotebook: FileNotebook
    
    private(set) var notes: [Note] = []
    
    init(fileNotebook: FileNotebook) {
        self.fileNotebook = fileNotebook
    }
    
    override func main() {
        fileNotebook.loadNotes()
        notes = fileNotebook.notes
    }
}
