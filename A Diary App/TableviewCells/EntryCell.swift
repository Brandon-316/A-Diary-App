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
        
        self.dateLabel.text = entry.entryDate.cellDateString
        self.entryLabel.text = entry.text
        self.entryImage.image = entry.image ?? UIImage(named: "NoImageIcon")
    }
    
    func roundImage() {
        entryImage.layer.cornerRadius = self.entryImage.frame.height / 2
        entryImage.clipsToBounds = true
    }
    
    func handleLocationStack(with location: String?) {
        if location != nil {
            // Location is not nil so check if location stack exists inside superView and add if not
            if locationStack == nil {
                self.addSubview(locationStack)
            }
            self.locationLabel.text = location
        } else {
            // Location is nil so if locationStack exists then remove it
            if locationStack != nil {
                locationStack.removeFromSuperview()
            }
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
