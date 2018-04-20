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

protocol VKDataInfo : class {
    var vkData: VKData { get }
}

protocol OperationFactory : class {
    
    func buildGetNoteListOperation() -> (GetNoteListOperation & NoteListable)
    
    func buildSaveNoteOperation(note: Note) -> (SaveNoteOperation & NoteListable)
    
    func buildUpdateNoteOperation(note: Note, index: Int) -> (UpdateNoteOperation & NoteListable)
    
    func buildRemoveNoteByUuidOperation(uuid: String) -> (RemoveNoteByUuidOperation & NoteListable)
    
    func buildPostNoteToVKOperation(note: Note) -> PostNoteToVKOperation
    
    func buildGetNoteByIdOperation(index: Int) -> (GetNoteByIdOperation & NoteListable)
    
    func buildAuthentificationVKOperation() -> AuthentificationVKOperation
    
    func buildSaveVKDataOperation(accessToken: String, ownerId: String) -> (SaveVKDataOperation & VKDataInfo)
    
    func buildGetVKDataOperation() -> (GetVKDataOperation & VKDataInfo)
    
    func buildGetNoteListFromVKOperation() -> GetNoteListFromVKOperation
    
    func buildSaveNoteListOperation(notes: [Note]) -> SaveNoteListOperation
}

class ConcreteOperationFactory : OperationFactory {
    private let fileNotebook: FileNotebook
    private let vkData: VKData
    
    init(fileNotebook: FileNotebook, vkData: VKData) {
        self.fileNotebook = fileNotebook
        self.vkData = vkData
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
    
    func buildPostNoteToVKOperation(note: Note) -> PostNoteToVKOperation {
        return PostNoteToVKOperation(accessToken: self.vkData.getAccessToken()!, ownerId: self.vkData.getOwnerId()!, note: note)
    }
    
    func buildGetNoteByIdOperation(index: Int) -> (GetNoteByIdOperation & NoteListable) {
        return GetNoteByIdOperation(fileNotebook: fileNotebook, index: index)
    }
    
    func buildAuthentificationVKOperation() -> AuthentificationVKOperation {
        return AuthentificationVKOperation()
    }
    
    func buildSaveVKDataOperation(accessToken: String, ownerId: String) -> (SaveVKDataOperation & VKDataInfo) {
        return SaveVKDataOperation(vkData: vkData, accessToken: accessToken, ownerId: ownerId)
    }
    
    func buildGetVKDataOperation() -> (GetVKDataOperation & VKDataInfo) {
        return GetVKDataOperation(vkData: vkData)
    }
    
    func buildGetNoteListFromVKOperation() -> GetNoteListFromVKOperation {
        guard let accessToken = vkData.getAccessToken(), let ownerId = vkData.getOwnerId() else { fatalError() }
        return GetNoteListFromVKOperation(accessToken: accessToken, ownerId: ownerId)
    }
    
    func buildSaveNoteListOperation(notes: [Note]) -> SaveNoteListOperation {
        return SaveNoteListOperation(fileNotebook: fileNotebook, notes: notes)
    }
}
