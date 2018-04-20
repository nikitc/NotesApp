import Foundation
import CocoaLumberjack

// Для каждой операции свой класс
// Операции производить в фабрике
// Операция знает об FileNoteBook? Да
//

class FileNotebook {
    
    private(set) var notes = [Note]()
    
    static var filepath: String? {
        guard let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first
            else {
                return nil
        }
        let path = "\(dir)/notes.plist"
        
        return path
    }
    
    func add(note: Note) {
        notes.append(note)
    }
    
    func updateNote(note: Note, index: Int) {
        notes[index] = note
    }
    
    func deleteNote(uuid: String) {
        notes = notes.filter { $0.uuid != uuid }
    }
    
    func saveAllNotes() {
        guard let path = FileNotebook.filepath
            else {
                return
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: notes.map {$0.json}, options: [])
            guard let strData = String.init(data: data, encoding: .utf8) as String?
                else {
                    return
            }
            try strData.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
            
            DDLogInfo("Notes saved")
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func loadNotes() {
        guard let path = FileNotebook.filepath else { return }
        
        do {
            let strData = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            let data = strData.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: AnyObject]]
            notes = []
            for noteData in json {
                notes.append(Note.parse(json: noteData)!)
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
}
