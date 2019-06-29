//
//  DataSource.swift
//  ToDoList
//
//  Created by Brandon Mahoney on 9/23/17.
//  Copyright © 2017 Brandon Mahoney. All rights reserved.
//

import Foundation
import  UIKit
import  CoreData

class DataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let tableView: UITableView
    private let context: NSManagedObjectContext
    private let tableVC: MasterViewController
    
    lazy var fetchedResultsController: DiaryFetchedResultsController = {
        return DiaryFetchedResultsController(managedObjectContext: self.context, predicate: nil, tableView: self.tableView)
    }()
    
    weak var delegate: EntrySelectionDelegate?
    
    //Initialize tableView for MasterViewController
    init(tableVC: MasterViewController, tableView: UITableView, context: NSManagedObjectContext) {
        self.tableView = tableVC.tableView
        self.context = context
        self.tableVC = tableVC
    }
    
    // MARK: - Table view datasource/delegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCell
        let dateString = fetchedResultsController.sections?[section].name ?? ""
        cell.configureCell(with: dateString)
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as! EntryCell
        let entry = fetchedResultsController.object(at: indexPath)
        
        cell.configure(with: entry)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        context.delete(item)
        context.saveChanges()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEntry = fetchedResultsController.object(at: indexPath)
        self.tableVC.delegate?.entrySelected(selectedEntry, with: self.tableVC.managedObjectContext)
        if let detailViewController = self.tableVC.delegate as? DetailViewController,
            let detailNavigationController = detailViewController.navigationController {
            self.tableVC.splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }

    
    
}


extension DataSource: UISearchBarDelegate, UISearchDisplayDelegate {
    
    // MARK: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var predicate: NSCompoundPredicate?
        
        //Set predicate based on scope button selected
        if !searchText.isEmpty {
            switch searchBar.selectedScopeButtonIndex {
                case 0:
                    let textPredicate = NSPredicate(format: "dateString CONTAINS[cd] %@", searchText.lowercased())
                    predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [textPredicate])
                case 1:
                    let textPredicate = NSPredicate(format: "text CONTAINS[cd] %@", searchText.lowercased())
                    predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [textPredicate])
                case 2:
                    //Mood search values are 'Bad', 'Average', and 'Good'
                    let textPredicate = NSPredicate(format: "mood CONTAINS[cd] %@", searchText.lowercased())
                    predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [textPredicate])
                default:
                    break
            }
        } else {
            predicate = nil
        }
        
        //Re fetch entries from Core Data with search predicate
        self.fetchedResultsController = DiaryFetchedResultsController(managedObjectContext: self.context, predicate: predicate, tableView: self.tableView)
        
        tableView.reloadData()
    }
    
}
