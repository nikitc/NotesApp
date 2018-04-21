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
    var uuid: String?
    
    @IBAction func postNoteVKAction(_ sender: Any) {
        var accessToken: String?
        let op = operationsFactory.buildGetVKDataOperation()
        let uop = BlockOperation { [op] in
            accessToken = op.accessToken
            
            if (accessToken == nil) {
                let refreshAlert = UIAlertController(title: "Download Notes", message: "You should sign in VK", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let newViewController = storyBoard.instantiateViewController(withIdentifier: "VKAuthViewController") as? VKAuthViewController else { fatalError("Failed to get controller") }
                    newViewController.operationsFactory = self.operationsFactory
                    self.navigationController?.pushViewController(newViewController, animated: true)
                }))
                
                self.present(refreshAlert, animated: true, completion: nil)
            } else {
                guard let currentNote = self.getNote() else { return }
                
                let op = self.operationsFactory.buildPostNoteToVKOperation(note: currentNote)
                let uop = BlockOperation { }
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
                self.present(alertController, animated: true, completion: nil)
            }
        }
        uop.addDependency(op)
        OperationQueue.main.addOperations([op, uop], waitUntilFinished: false)
    }
    
    @IBAction func saveNoteAction(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        var op: Operation
        guard let note = getNote() else { return }
        
        if uuid != nil {
            op = operationsFactory.buildUpdateNoteOperation(note: note)
        } else {
            op = operationsFactory.buildSaveNoteOperation(note: note)
        }
        
        let uop = BlockOperation { }
        uop.addDependency(op)
        OperationQueue.main.addOperations([op, uop], waitUntilFinished: false)
        
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
        if self.uuid == nil {
            self.postNoteVKButton?.isHidden = true
        }
        if let currentUuid = uuid {
            let op = operationsFactory.buildGetNoteByUUIDOperation(uuid: currentUuid)
            let uop = BlockOperation { [op] in
                if let currentNote = op.note {
                    self.setDataNote(note: currentNote)
                } else {
                    return
                }
            }
            uop.addDependency(op)
            OperationQueue.main.addOperations([op, uop], waitUntilFinished: false)
        } else {
            return
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
            fatalError("Color missing")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? VKAuthViewController)?.operationsFactory = self.operationsFactory
    }
    
    public func getNote() -> Note? {
        let color = colorEdit.selectedSegmentIndex.color
        let importance = importantEdit.selectedSegmentIndex.importance
        
        if let currentuuid = self.uuid {
            return Note(title: titleEdit.text ?? "", content: contentEdit.text ?? "", importance: importance, uuid: currentuuid, color: color)
        } else {
            return Note(title: titleEdit.text ?? "", content: contentEdit.text ?? "", importance: importance, color: color)
        }
        
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
            fatalError("Color missing")
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
            fatalError("Importance missing")
        }
    }
}
