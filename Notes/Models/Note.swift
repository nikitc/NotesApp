import Foundation
import UIKit

struct Note {
    let title: String
    let content: String
    let importance: Importance
    let uuid: String
    let color: UIColor
    
    init(title: String,
         content: String,
         importance: Importance = Importance.normal,
         uuid: String = UUID().uuidString,
         color: UIColor = UIColor.green) {
        self.title = title
        self.content = content
        self.importance = importance
        self.uuid = uuid
        self.color = color
    }
}

extension Note {
    static func map(entity: NoteEntity) -> Note? {
        guard let title = entity.title,
            let content = entity.content,
            let uuid = entity.uuid
            else {
                return nil
        }
        
        let color = entity.color.flatMap{ UIColor(hex: $0) } ?? UIColor(hex: "FFFFF")
        let importance = entity.importance.flatMap{ Importance(rawValue: $0) } ?? .normal
        
        return Note(title: title,
                    content: content,
                    importance: importance,
                    uuid: uuid,
                    color: color)
    }
}
