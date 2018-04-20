//
//  TableViewCell.swift
//  Notes
//
//  Created by Admin on 22.03.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var colorNoteImage: UIView!
    @IBOutlet weak var titleNote: UILabel!
    @IBOutlet weak var contentNote: UILabel!
    
    var note : Note?
    
    func initCell(note: Note) {
        self.note = note
        
        titleNote.text = note.title
        contentNote.text = note.content
        colorNoteImage.layer.cornerRadius = colorNoteImage.frame.size.width / 2
        colorNoteImage.clipsToBounds = true
        colorNoteImage.backgroundColor = note.color
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let v = UIView(frame: bounds)
        v.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        selectedBackgroundView = v
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.colorNoteImage.alpha = highlighted ? 0.25 : 1.0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
