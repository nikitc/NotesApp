import Foundation
import UIKit

struct Note {
    static let defaultColor = UIColor.white
    
    let title: String
    let content: String
    let importance: Importance
    let uuid: String
    let color: UIColor
    
    init(title: String,
         content: String,
         importance: Importance,
         uuid: String = UUID().uuidString,
         color: UIColor) {
        self.title = title
        self.content = content
        self.importance = importance
        self.uuid = uuid
        self.color = color
    }
}

extension Note {
    var json: [String: Any] {
        get {
            var dict = [String: Any]()
            dict["title"] = self.title
            dict["content"] = self.content
            dict["uuid"] = self.uuid
            if (self.importance != .normal) {
                dict["importance"] = self.importance.rawValue
            }
            
            if (self.color != UIColor.white) {
                dict["color"] = self.color.htmlRGB
            }
            
            return dict
        }
    }
    
    static func parse(json: [String: Any]) -> Note? {
        guard let title = json["title"] as? String,
            let content = json["content"] as? String,
            let uuid = json["content"] as? String
            else {
                return nil
        }
        
        let color = (json["content"] as? String).flatMap{ UIColor(hex: $0) } ?? UIColor(hex: "FFFFF")
        let importance = (json["importance"] as? String).flatMap{ Importance(rawValue: $0) } ?? .normal
        
        return Note(title: title,
                    content: content,
                    importance: importance,
                    uuid: uuid,
                    color: color)
    }
}
