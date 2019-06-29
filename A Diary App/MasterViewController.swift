//
//  MasterViewController.swift
//  A Diary App
//
//  Created by Brandon Mahoney on 1/3/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import UIKit
import CoreData

//Protocol for sending selected entry to DetailViewController
protocol EntrySelectionDelegate: class {
    func entrySelected(_ newEntry: Entry?, with context: NSManagedObjectContext)
}

class MasterViewController: UITableViewController {

    //MARK: - Properties
    var detailViewController: DetailViewController? = nil
    
    let managedObjectContext = CoreDataStack().managedObjectContext
    
    lazy var dataSource: DataSource = {
        return DataSource(tableVC: self, tableView: self.tableView, context: self.managedObjectContext)
    }()
    
    weak var delegate: EntrySelectionDelegate?
    
    
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    

    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
        self.searchBar.delegate = dataSource
        
        self.setNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    

    //MARK: Methods
    func setNavBar() {
        let date = Date()
        self.title = date.navBarDateString
    }
    
    
    
    //MARK: Actions
    //Create a new blank entry
    @IBAction func createEntry(_ sender: Any) {
        self.delegate?.entrySelected(nil, with: self.managedObjectContext)
        if let detailViewController = self.delegate as? DetailViewController,
            let detailNavigationController = detailViewController.navigationController {
            self.splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }
    
    
}

