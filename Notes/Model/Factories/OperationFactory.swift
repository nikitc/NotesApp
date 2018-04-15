//
//  OperationFactory.swift
//  Notes
//
//  Created by Admin on 14.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import Foundation

protocol NoteListable : class {
    var notes: [Note] { get }
}

protocol OperationFactory : class {
    func buildGetNoteListOperation() -> (GetNoteListOperation & NoteListable)
    
    func buildSaveNoteOperation(note: Note) -> (SaveNoteOperation & NoteListable)
    
    func buildUpdateNoteOperation(note: Note, index: Int) -> (UpdateNoteOperation & NoteListable)
    
    func buildRemoveNoteByUuidOperation(uuid: String) -> (RemoveNoteByUuidOperation & NoteListable)
    
    func buildPostNoteToVKOperation(note: Note) -> (PostNoteToVKOperation)
}

class ConcreteOperationFactory : OperationFactory {
    private let fileNotebook: FileNotebook
    private let accessToken = ""
    private let ownerId = ""
    
    init(fileNotebook: FileNotebook) {
        self.fileNotebook = fileNotebook
    }
    
    func buildGetNoteListOperation() -> (GetNoteListOperation & NoteListable) {
        return GetNoteListOperation(fileNotebook: fileNotebook)
    }
    
    func buildSaveNoteOperation(note: Note) -> (SaveNoteOperation & NoteListable) {
        return SaveNoteOperation(fileNotebook: fileNotebook, note: note)
    }
    
    func buildUpdateNoteOperation(note: Note, index: Int) -> (UpdateNoteOperation & NoteListable) {
        return UpdateNoteOperation(fileNotebook: fileNotebook, note: note, index: index)
    }
    
    func buildRemoveNoteByUuidOperation(uuid: String) -> (RemoveNoteByUuidOperation & NoteListable) {
        return RemoveNoteByUuidOperation(fileNotebook: fileNotebook, uuid: uuid)
    }
    
    func buildPostNoteToVKOperation(note: Note) -> (PostNoteToVKOperation) {
        return PostNoteToVKOperation(accessToken: self.accessToken, ownerId: self.ownerId, note: note)
    }
}
