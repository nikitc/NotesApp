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
        notesFromVK.append(Note(title: "1", content: "Test note"))
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notesFromVK.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteFromVKCell", for: indexPath)

        let currentText = notesFromVK[indexPath.row]
        cell.textLabel?.text = currentText.content
        // Configure the cell...

        return cell
    }
    
    @IBAction func DownloadButtonAction(_ sender: Any) {
        var accessToken: String?
        let op = operationsFactory.buildGetVKDataOperation()
        let uop = BlockOperation { [op] in
            accessToken = op.accessToken
            
            if (accessToken == nil) {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "VKAuthViewController") as! VKAuthViewController
                newViewController.operationsFactory = self.operationsFactory
                self.navigationController?.pushViewController(newViewController, animated: true)
            } else {
                let op = self.operationsFactory.buildGetNoteListFromVKOperation()
                let uop = BlockOperation { [op] in
                    self.notesFromVK = op.notes
                    self.tableView.reloadData()
                }
                uop.addDependency(op)
                OperationQueue.main.addOperations([op, uop], waitUntilFinished: false)
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
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
