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
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var postNoteVKButton: UIButton!
    weak var operationsFactory: OperationFactory!
    
    var note: Note?
    
    @IBAction func postNoteVKAction(_ sender: Any) {
        let currentNote = getNote()
        let op = operationsFactory.buildPostNoteToVKOperation(note: currentNote!)
        let uop = BlockOperation { [op] in
            print("Success")
        }
        
        uop.addDependency(op)
        OperationQueue.main.addOperations([op, uop], waitUntilFinished: false)
        
        let alertController = UIAlertController(title: "Note", message: "Note was published VK", preferredStyle: .alert)
        
        let callActionHandler = { [weak self, alertController] (action:UIAlertAction!) -> Void in
            CATransaction.begin()
            alertController.dismiss(animated: true, completion: nil)
            self?.navigationController?.popViewController(animated: true)
            CATransaction.commit()
        }
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: callActionHandler)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveNoteAction(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        let alertController = UIAlertController(title: "Note", message: "Note was saved successfully", preferredStyle: .alert)
        
        let callActionHandler = { [weak self, alertController] (action:UIAlertAction!) -> Void in
            CATransaction.begin()
            alertController.dismiss(animated: true, completion: nil)
            self?.navigationController?.popViewController(animated: true)
            CATransaction.commit()
        }
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: callActionHandler)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    public func getNote() -> Note? {
        let color = colorEdit.selectedSegmentIndex.color
        let importance = importantEdit.selectedSegmentIndex.importance
        
        return Note(title: titleEdit.text ?? "", content: contentEdit.text ?? "", importance: importance, color: color)
    }
}

private extension Int {
    var color: UIColor {
        switch self {
        case 0:
            return UIColor.red
        case 1:
            return UIColor.green
        case 2:
            return UIColor.blue
        default:
            fatalError()
        }
    }
    
    var importance: Importance {
        switch self {
        case 0:
            return Importance.important
        case 1:
            return Importance.normal
        case 2:
            return Importance.unimportant
        default:
            fatalError()
        }
    }
}
