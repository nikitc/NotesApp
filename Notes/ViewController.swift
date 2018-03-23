//
//  ViewController.swift
//  Notes
//
//  Created by Admin on 22.03.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  
    @IBOutlet weak var titleEdit: UITextField!
    @IBOutlet weak var contentEdit: UITextView!
    @IBOutlet weak var colorEdit: UISegmentedControl!
    @IBOutlet weak var importantEdit: UISegmentedControl!
    
    @IBAction func saveNoteAction(_ sender: Any) {
        var color : UIColor?
        var importance : Importance?
        switch colorEdit.selectedSegmentIndex {
        case 0:
            color = UIColor.red
        case 1:
            color = UIColor.green
        case 2:
            color = UIColor.blue
        default:
            print("color missing")
        }
        
        switch importantEdit.selectedSegmentIndex {
        case 0:
            importance = Importance.important
        case 1:
            importance = Importance.normal
        case 2:
            importance = Importance.unimportant
        default:
            print("importance missing")
        }
        if let i = importance, let c = color {
            note = Note(title: titleEdit.text ?? "", content: contentEdit.text ?? "", importance: i, color: c)
        }
        
        if let index = indexNote {
            TableViewController.notes[index] = note!
        } else {
            TableViewController.notes.append(note!)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    @IBOutlet weak var saveButton: UIButton!
    
    var indexNote: Int?
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let note = note {
            setDataNote(note: note)
        }
    }
    
    func setDataNote(note: Note) {
        titleEdit.text = note.title
        contentEdit.text = note.content
        switch note.importance {
        case Importance.important:
            importantEdit.selectedSegmentIndex = 0
        case Importance.normal:
            importantEdit.selectedSegmentIndex = 1
        case Importance.unimportant:
            importantEdit.selectedSegmentIndex = 2
        }
        
        switch note.color {
        case UIColor.red:
            colorEdit.selectedSegmentIndex = 0
        case UIColor.green:
            colorEdit.selectedSegmentIndex = 1
        case UIColor.blue:
            colorEdit.selectedSegmentIndex = 2
        default:
            print("color missing")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    

}
