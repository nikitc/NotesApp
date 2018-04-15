//
//  TableViewController.swift
//  Notes
//
//  Created by Admin on 22.03.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    private var notes: [Note] = []
    weak var operationsFactory: OperationFactory!
    private var editingCellIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        
        let op = operationsFactory.buildGetNoteListOperation()
        let uop = BlockOperation { [op] in
            self.notes = op.notes
            self.tableView.reloadData()
        }
        
        uop.addDependency(op)
        OperationQueue.main.addOperations([op, uop], waitUntilFinished: false)
 
        
       // let note1 = Note(title: "Test1", content: "Content1", importance: Importance.normal, color: UIColor.green)
       // TableViewController.notes.append(note1)
    }
    
    @objc func loadList(notification: NSNotification) {
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath) as? TableViewCell
            else {
                return UITableViewCell()
        }
        let currentNote = self.notes[indexPath.row]
        cell.initCell(note: currentNote)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteToDelete = notes[indexPath.row]
            let op = operationsFactory.buildRemoveNoteByUuidOperation(uuid: noteToDelete.uuid)
            let uop = BlockOperation { [op] in
                self.notes.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                //self.notes = op.notes
                //self.tableView.reloadData()
            }
            
            uop.addDependency(op)
            OperationQueue.main.addOperations([op, uop], waitUntilFinished: false)
        } else if editingStyle == .insert {
        }    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let row = tableView.indexPathForSelectedRow {
            let index = row.row
            let selectedNote = self.notes[index]
            editingCellIndex = index
            (segue.destination as? ViewController)?.note = selectedNote
        }
    }
    
    @IBAction func returnToNotesList(sender: UIStoryboardSegue) {
        let cellIndex = editingCellIndex
        editingCellIndex = nil
        guard let sourceViewController = sender.source as? ViewController,
            let note = sourceViewController.getNote() else {
                return
        }

        if let cellIndex = cellIndex {
            let op = operationsFactory.buildUpdateNoteOperation(note: note, index: cellIndex)
            
            let uop = BlockOperation { [op] in
                //self.notes = op.notes
                self.notes[cellIndex] = note
                self.tableView.reloadData()
            }
            
            uop.addDependency(op)
            OperationQueue.main.addOperations([op, uop], waitUntilFinished: false)
        } else {
            let op = operationsFactory.buildSaveNoteOperation(note: note)
            
            let uop = BlockOperation { [op] in
                //self.notes = op.notes
                self.notes.append(note)
                self.tableView.reloadData()
            }
            
            uop.addDependency(op)
            OperationQueue.main.addOperations([op, uop], waitUntilFinished: false)
        }
    }
}
