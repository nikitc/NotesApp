//
//  TableViewCell.swift
//  Notes
//
//  Created by Admin on 22.03.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var colorNoteImage: UIImageView!
    @IBOutlet weak var titleNote: UILabel!
    @IBOutlet weak var contentNote: UILabel!
    
    var note : Note?
    
    func initCell(note: Note) {
        self.note = note
        
        titleNote.text = note.title
        contentNote.text = note.content
        colorNoteImage.image = UIImage()
        colorNoteImage.layer.cornerRadius = colorNoteImage.frame.size.width / 2
        colorNoteImage.clipsToBounds = true
        colorNoteImage.backgroundColor = note.color
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
