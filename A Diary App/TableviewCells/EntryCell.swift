//
//  EntryCell.swift
//  A Diary App
//
//  Created by Brandon Mahoney on 1/10/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {
    
    //MARK: Properties
    var locationStackConstraints: [NSLayoutConstraint] = []
    
    //MARK: Outlets
    @IBOutlet weak var entryImage: UIImageView!
    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet var locationStack: UIStackView!
    @IBOutlet var locationLabel: UILabel!
    

    //MARK: Methods
    func configure(with entry: Entry) {
        roundImage()
        handleLocationStack(with: entry.location)
        handleMoodIcon(with: entry.mood)
        
        self.dateLabel.text = entry.dateStringWithoutYear
        self.entryLabel.text = entry.text
        self.entryImage.image = entry.image ?? UIImage(named: "NoImageIcon")
    }
    
    func roundImage() {
        entryImage.layer.cornerRadius = self.entryImage.frame.height / 2
        entryImage.clipsToBounds = true
    }
    
    func handleLocationStack(with location: String?) {
        //Make sure constraints are up to date
        locationStack.updateConstraints()
        
        //Check that locationStackConstraints are set
        if locationStackConstraints.isEmpty && !locationStack.constraints.isEmpty {
            print("Saved constraints")
            locationStackConstraints = locationStack.constraints
        }
        
        if location != nil {
            // Location is not nil
            // Check if locationStack constraints are not set then set label text
            print("Location wasn't nil")
            if locationStack == nil {
                self.addSubview(locationStack)
            }
//            if locationStack.constraints.isEmpty {
//                locationStack.addConstraints(constraints)
//                locationStack.isHidden = false
//            }
            self.locationLabel.text = location
        } else {
            // Location is nil
            // Check if locationStack constraints are set
            print("Location is nil")
            
            if locationStack != nil {
                locationStack.removeFromSuperview()
            }
            
//            if !locationStack.constraints.isEmpty {
//                print("Location constraints are not empty")
//                locationStack.removeConstraints(locationStackConstraints)
////                locationStack.addConstraint(locationStackHeight)
//                locationStack.isHidden = true
//                self.layoutIfNeeded()
//            }
        }
    }
    
    func handleMoodIcon(with mood: String?) {
        if let mood = mood {
            switch mood {
                case "Average": moodImage.image = #imageLiteral(resourceName: "AverageFace")
                case "Bad": moodImage.image = #imageLiteral(resourceName: "BadFace")
                case "Good": moodImage.image = #imageLiteral(resourceName: "HappyFace")
                default: moodImage.image = #imageLiteral(resourceName: "AverageFace")
            }
            moodImage.alpha = 1.0
        } else {
            moodImage.alpha = 0
        }
    }

}
