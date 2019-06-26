//
//  ToDoFetchedResultsController.swift
//  ToDoList
//
//  Created by Brandon Mahoney on 9/23/17.
//  Copyright © 2017 Brandon Mahoney. All rights reserved.
//

import UIKit
import CoreData

class DiaryFetchedResultsController: NSFetchedResultsController<Entry>, NSFetchedResultsControllerDelegate {
    private let tableView: UITableView
    
    init(managedObjectContext: NSManagedObjectContext, tableView: UITableView) {
        self.tableView = tableView
        super.init(fetchRequest: Entry.fetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: "monthYear", cacheName: nil)
        self.delegate = self
        
        tryFetch()
    }
    
    func tryFetch() {
        do {
            try performFetch()
        } catch {
            print("Unresolved error: \(error.localizedDescription)")
        }
    }
    
    //MARK: Fetched Results Controller Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                guard let newIndexPath = newIndexPath else { return }
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            case .delete:
                guard  let indexPath = indexPath else { return }
                
                if tableView.numberOfRows(inSection: indexPath.section) > 1 {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    print("\nDeleted Row\n")
                } else {
                    let indexSet = IndexSet(integer: indexPath.section)
                    tableView.deleteSections(indexSet as IndexSet, with: .automatic)
                    print("\nDeleted Section\n")
            }
            case .update, .move:
                guard let indexPath = indexPath else { return }
                tableView.reloadRows(at: [indexPath], with: .automatic)
        default: return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
            case .insert:
                tableView.insertSections(indexSet, with: .automatic)
            case .delete:
                tableView.deleteSections(indexSet, with: .automatic)
            case .update:
                tableView.reloadSections(indexSet, with: .automatic)
            default: return
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
