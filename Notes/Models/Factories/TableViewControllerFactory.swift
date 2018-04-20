//
//  ViewControllerFactory.swift
//  Notes
//
//  Created by Admin on 14.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewControllerFactory : class {
    func buildTableViewController() -> UITableViewController?
}

class ConcreteTableViewControllerFactory : TableViewControllerFactory {
    let operationFactory: OperationFactory!
    init(operationFactory: OperationFactory) {
        self.operationFactory = operationFactory
    }
    
    func buildTableViewController() -> UITableViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tvc = storyboard.instantiateViewController(
            withIdentifier: "TableViewController") as? TableViewController else { return nil }
        tvc.operationsFactory = operationFactory
        return tvc
    }
}
