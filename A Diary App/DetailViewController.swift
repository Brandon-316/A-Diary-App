//
//  DetailViewController.swift
//  A Diary App
//
//  Created by Brandon Mahoney on 1/3/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    //MARK: Properties
    var date: Date?
    var entry: Entry?
    var currentMood: Moods?
    
    var managedObjectContext: NSManagedObjectContext!
    
    var detailItem: Entry? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    //MARK: Outlets
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var entryImage: UIImageView!
    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var entryText: UITextView!
    @IBOutlet weak var locationStack: UIStackView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        // Set up tap gestures
        let dateGesture = UITapGestureRecognizer(target: self, action: #selector(dateLabelTapped))
        dateLabel.addGestureRecognizer(dateGesture)
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        entryImage.addGestureRecognizer(imageGesture)
        let locationGesture = UITapGestureRecognizer(target: self, action: #selector(locationTapped))
        locationStack.addGestureRecognizer(locationGesture)
        
        NotificationCenter.default.addObserver(forName: NSNotifications().dateSaved, object: nil, queue: OperationQueue.main) { (notification) in
            let date = notification.object as! Date
            self.date = date
            self.dateLabel.text = date.cellDateString
        }
        
        NotificationCenter.default.addObserver(forName: NSNotifications().locationSaved, object: nil, queue: OperationQueue.main) { (notification) in
            let location = notification.object as! String
            self.locationLabel.text = location
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //MARK: Methods
    @objc func dateLabelTapped(sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "EntryDateSegue", sender: nil)
    }
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        presentImagePicker()
    }
    @objc func locationTapped(sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "MapSegue", sender: nil)
    }
    
    func configureView() {
        entryImage.layer.cornerRadius = entryImage.frame.height / 2
        entryImage.clipsToBounds = true
    }
    
    
    func handleSettingMood(with mood: Moods) {
        if mood == currentMood {
            self.moodImage.image = nil
            self.currentMood = nil
        } else {
            self.moodImage.image = mood.image
            self.currentMood = mood
        }
    }
    
    //MARK: Actions
    @IBAction func moodSelected(_ sender: UIButton) {
        switch sender.accessibilityIdentifier {
            case "badMood": self.handleSettingMood(with: .bad)
            case "averageMood": self.handleSettingMood(with: .average)
            case "goodMood": self.handleSettingMood(with: .good)
            default: return
        }
    }
    
    @IBAction func save(_ sender: Any) {
        
        guard let text = entryText.text, let date = date, !text.isEmpty else { print("Text was empty"); return }
        var image: UIImage?
        
        if entryImage.image != #imageLiteral(resourceName: "NoImageIcon") {
            image = entryImage.image
        }
        
        let _ = Entry.with(text: entryText.text, date: date, image: image, mood: currentMood, location: locationLabel.text, in: managedObjectContext)
        managedObjectContext.saveChanges()
        
        navigationController?.navigationController?.popToRootViewController(animated: true)
    }


}

