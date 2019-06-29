//
//  DetailViewController.swift
//  A Diary App
//
//  Created by Brandon Mahoney on 1/3/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class DetailViewController: UIViewController, UITextViewDelegate {
    
    //MARK: - Properties
    var date: Date?
    var currentMood: Moods?
    var managedObjectContext: NSManagedObjectContext!
    var detailItem: Entry? {
        didSet {
            updateView()
        }
    }
    var locationPoint: CLLocation?

    //MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var entryImage: UIImageView!
    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var entryText: UITextView!
    @IBOutlet weak var locationStack: UIStackView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    
    
    //MARK: - Override Methods
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
        
        self.entryText.delegate = self
        
    }
    
    //Used to dismiss keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EntryDateSegue" {
            let destinationVC = segue.destination as! DatePopUp
            destinationVC.entryDate = self.date
            
            destinationVC.onSave = { (date) in
                self.date = date
                self.dateLabel.text = date.detailDateString
            }
        }
        
        if segue.identifier == "MapSegue" {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.entryLocation = self.locationPoint
            
            destinationVC.onSave = { (location) in
                self.locationLabel.text = location.locationString
                self.locationPoint = location.location
            }
        }
        
    }
    
    
    //MARK: - Methods
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
    
    func updateView() {
        loadViewIfNeeded()
        if let entry = self.detailItem {
            if entry.image != nil { self.entryImage.image = entry.image }
            self.date = entry.entryDate
            self.dateLabel.text = entry.entryDate.detailDateString
            self.entryText.text = entry.text
            self.characterCountLabel.text = String(self.entryText.text.count)
            
            if entry.location != nil {
                self.locationLabel.text = entry.location
            }
            if entry.locationPoint != nil {
                self.locationPoint = entry.locationPoint
            } else {
                self.locationPoint = nil
            }
            
            if let moodString = entry.mood {
                self.setMood(moodString: moodString, from: false)
            } else {
                self.moodImage.image = nil
            }
        } else {
            self.date = nil
            self.entryImage.image = #imageLiteral(resourceName: "NoImageIcon")
            self.dateLabel.text = "Tap here to set date"
            self.entryText.text = ""
            self.characterCountLabel.text = "0"
            self.locationLabel.text = "Add location"
            self.locationPoint = nil
            self.currentMood = nil
            self.moodImage.image = nil
        }
            
    }
    
    
    func handleSettingMood(with mood: Moods, from buttonPressed: Bool) {
        if mood == currentMood && buttonPressed {
            self.moodImage.image = nil
            self.currentMood = nil
        } else {
            self.moodImage.image = mood.image
            self.currentMood = mood
        }
    }
    
    //Set Moods enum value and moodImage
    func setMood(moodString: String, from buttonPressed: Bool) {
        switch moodString {
            case "Bad": self.handleSettingMood(with: .bad, from: buttonPressed)
            case "Average": self.handleSettingMood(with: .average, from: buttonPressed)
            case "Good": self.handleSettingMood(with: .good, from: buttonPressed)
            default: return
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let characterCount = textView.text.count
        let countString = String(characterCount)
        self.characterCountLabel.text = countString
    }
    
    func entryTextGreaterThan200() -> Bool {
        if self.entryText.text.count > 200 { return true }
        return false
    }
    
    //MARK: - Actions
    @IBAction func moodSelected(_ sender: UIButton) {
        if let moodString = sender.accessibilityIdentifier {
            self.setMood(moodString: moodString, from: true)
        }
    }
    
    @IBAction func save(_ sender: Any) {
        
        //Check if user has entered required fields
        guard let text = entryText.text, let date = date, !text.isEmpty else { AlertUser().generalAlert(title: "Fields Missing", message: "Date and text field are required", vc: self); return }
        
        //Check that text is less than the 200 character allowance
        if self.entryTextGreaterThan200() {
            AlertUser().generalAlert(title: "Over Maximum Characters", message: "Your journal entry must not have more than 500 characters", vc: self)
            return
        }
        
        var image: UIImage?
        var imageData: NSData?
        
        //Check for selected image
        if let selectedImage = entryImage.image {
            if selectedImage != #imageLiteral(resourceName: "NoImageIcon") {
                image = selectedImage
                imageData = selectedImage.jpegData(compressionQuality: 1.0)! as NSData
            } else {
                image = nil
                imageData = nil
            }
        }
        
        var latitude: String?
        var longitude: String?
        
        //Check if location selected and create latitude/longitude points
        if let locationPoint = self.locationPoint {
            latitude = String(locationPoint.coordinate.latitude)
            longitude = String(locationPoint.coordinate.longitude)
        }
        
        //Check if location text is not nil and set regional name of loaction
        var locationString: String?
        if locationLabel.text != "Add Location" {
            locationString = locationLabel.text
        }
        
        //Check if editing entry
        if self.detailItem != nil {
            self.detailItem?.date = date as NSDate
            self.detailItem?.dateString = date.detailDateString
            self.detailItem?.imageData = imageData
            self.detailItem?.text = text
            self.detailItem?.mood = self.currentMood?.moodDescriptor
            self.detailItem?.location = locationString
            self.detailItem?.latitude = latitude
            self.detailItem?.longitude = longitude
        } else {
            //If not editing an entry than create a new one
            let _ = Entry.with(text: entryText.text, date: date, image: image, mood: currentMood, location: locationString, latitude: latitude, longitude: longitude, in: managedObjectContext)
        }
        
        managedObjectContext.saveChanges()
        
        navigationController?.navigationController?.popToRootViewController(animated: true)
    }


}

//MARK: - EntrySelectionDelegate
extension DetailViewController: EntrySelectionDelegate {
    func entrySelected(_ newEntry: Entry?, with context: NSManagedObjectContext) {
        self.detailItem = newEntry
        self.managedObjectContext = context
    }
    
}

