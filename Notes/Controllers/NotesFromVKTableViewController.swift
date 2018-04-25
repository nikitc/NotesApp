//
//  NotesFromVKTableViewController.swift
//  Notes
//
//  Created by Admin on 20.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import UIKit

class NotesFromVKTableViewController: UITableViewController {

    @IBOutlet weak var DownloadButton: UIButton!
    @IBOutlet weak var SaveNotesButton: UIButton!
    
    private var notesFromVK: [Note] = []
    weak var operationsFactory: OperationFactory!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesFromVK.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteFromVKCell", for: indexPath)
        let currentText = notesFromVK[indexPath.row]
        cell.textLabel?.text = currentText.content

        return cell
    }
    
    @IBAction func DownloadButtonAction(_ sender: Any) {
        var accessToken: String?
        let op = operationsFactory.buildGetVKDataOperation()
        let urlQueue = OperationQueue()
        
        let uop = BlockOperation { [op] in
            accessToken = op.accessToken
            
            if (accessToken == nil) {
                let refreshAlert = UIAlertController(title: "Download Notes", message: "You should sign in VK", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "VKAuthViewController") as! VKAuthViewController
                    newViewController.operationsFactory = self.operationsFactory
                    self.navigationController?.pushViewController(newViewController, animated: true)
                }))
                
                self.present(refreshAlert, animated: true, completion: nil)
            } else {
                
                let op = self.operationsFactory.buildGetNoteListFromVKOperation()
                urlQueue.addOperations([op], waitUntilFinished: false)
                let uop = BlockOperation { [op] in
                    self.notesFromVK = op.notes
                    self.tableView.reloadData()
                }
                
                uop.addDependency(op)
                OperationQueue.main.addOperations([uop], waitUntilFinished: false)
            }
        }
        uop.addDependency(op)
        OperationQueue.main.addOperations([op, uop], waitUntilFinished: false)
    }
    
    @IBAction func SaveNotesAction(_ sender: Any) {
        let op = operationsFactory.buildSaveNoteListOperation(notes: self.notesFromVK)
        let uop = BlockOperation { }
        uop.addDependency(op)
        OperationQueue.main.addOperations([op, uop], waitUntilFinished: false)
        
        let alertController = UIAlertController(title: "Notes", message: "Notes was saved successfully", preferredStyle: .alert)
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = self.notesFromVK[indexPath.row]
        let op = operationsFactory.buildSaveNoteOperation(note: note)
        let uop = BlockOperation { }
        uop.addDependency(op)
        OperationQueue.main.addOperations([op, uop], waitUntilFinished: false)
        
        
        let alertController = UIAlertController(title: "Notes", message: "Note was saved successfully", preferredStyle: .alert)
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
}
