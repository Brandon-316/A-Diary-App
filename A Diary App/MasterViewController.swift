//
//  MasterViewController.swift
//  A Diary App
//
//  Created by Brandon Mahoney on 1/3/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController/*, NSFetchedResultsControllerDelegate*/ {

    var detailViewController: DetailViewController? = nil
//    var managedObjectContext: NSManagedObjectContext? = nil
    
    let managedObjectContext = CoreDataStack().managedObjectContext
    
    lazy var dataSource: DataSource = {
        return DataSource(tableView: self.tableView, context: self.managedObjectContext)
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        self.tableView.dataSource = dataSource
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
//            if let indexPath = tableView.indexPathForSelectedRow {
            
//            let object = fetchedResultsController.object(at: indexPath)
                let navigationController = segue.destination as! UINavigationController
                let addTaskController = navigationController.topViewController as! DetailViewController
                
                addTaskController.managedObjectContext = self.managedObjectContext
                
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
    }


    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    @IBAction func createEntry(_ sender: Any) {
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
}

