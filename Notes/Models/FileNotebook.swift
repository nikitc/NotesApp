import Foundation
import CocoaLumberjack
import CoreData

class FileNotebook {
    private let dataManager = DataController().managedObjectContext
    
    func getNoteByUUID(uuid: String) -> Note {
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "uuid == %@", uuid)
        
        do {
            guard let object = try dataManager.fetch(fetchRequest).first else { fatalError("Could not get note by uuid") }
            guard let note = Note.map(entity: object) else { fatalError("Could not map note") }
            return note
        }
        catch {
            fatalError("Note with such uuid not found")
        }
    }
    
    func add(note: Note) {
        let noteEntity = NSEntityDescription.insertNewObject(forEntityName: "NoteEntity", into: dataManager)
        
        noteEntity.setValue(note.title, forKey: "title")
        noteEntity.setValue(note.content, forKey: "content")
        noteEntity.setValue(note.color.htmlRGB, forKey: "color")
        noteEntity.setValue(note.importance.rawValue, forKey: "importance")
        noteEntity.setValue(note.uuid, forKey: "uuid")
        
        do {
            try dataManager.save()
        }
        catch {
            fatalError("Could not add note")
        }
    }
    
    func updateNote(note: Note) {
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "uuid == %@", note.uuid)
        
        do {
            let objects = try dataManager.fetch(fetchRequest)
            for object in objects {
                object.title = note.title
                object.content = note.content
                object.importance = note.importance.rawValue
                object.color = note.color.htmlRGB
            }
            try dataManager.save()
        }
        catch {
            fatalError("Could not update note")
        }
    }
    
    func deleteNoteByUUID(uuid: String) {
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "uuid == %@", uuid)
        
        do {
            let objects = try dataManager.fetch(fetchRequest)
            for object in objects {
                dataManager.delete(object)
            }
            try dataManager.save()
        }
        catch {
            fatalError("Could not delete note")
        }
    }
    
    func getAllNotes() -> [Note] {
        let fetchRequest = NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
        var notes: [Note] = []
        do {
            let objects = try dataManager.fetch(fetchRequest)
            for object in objects {
                guard let currentNote = Note.map(entity: object) else { fatalError("Could not map note") }
                
                notes.append(currentNote)
            }
        }
        catch {
            fatalError("Could not get all notes")
        }
        
        return notes
    }
}
