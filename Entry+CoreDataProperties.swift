//
//  Entry+CoreDataProperties.swift
//  A Diary App
//
//  Created by Brandon Mahoney on 6/28/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//
//

import Foundation
import UIKit
import CoreData
import CoreLocation

//@objc(Entry)
public class Entry: NSManagedObject {}

extension Entry {

    @nonobjc public class func fetchRequest(predicate: NSPredicate?) -> NSFetchRequest<Entry> {
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.predicate = predicate

        return request
    }

    @NSManaged public var date: NSDate
    @NSManaged public var dateString: String
    @NSManaged public var imageData: NSData?
    @NSManaged public var location: String?
    @NSManaged public var mood: String?
    @NSManaged public var text: String
    @NSManaged public var longitude: String?
    @NSManaged public var latitude: String?

}

extension Entry {
    static var entityName: String {
        return String(describing: Entry.self)
    }
    
    
    @nonobjc class func with(text: String, date: Date, image: UIImage?, mood: Moods?, location: String?, latitude: String?, longitude: String?, in context: NSManagedObjectContext) -> Entry {
        let entry = NSEntityDescription.insertNewObject(forEntityName: Entry.entityName, into: context) as! Entry
        
        entry.text = text
        entry.date = date as NSDate
        entry.dateString = date.detailDateString
        
        if let image = image {
            entry.imageData = image.jpegData(compressionQuality: 1.0)! as NSData
        }
        
        if let mood = mood {
            entry.mood = mood.moodDescriptor
        }
        
        if let location = location {
            entry.location = location
        }
        
        if let latitude = latitude, let longitude = longitude {
            entry.latitude = latitude
            entry.longitude = longitude
        }
        
        
        
        return entry
    }
}

extension Entry {
    var image: UIImage? {
        // Check if image data exists and return image
        if let imageData = self.imageData {
            if let image = UIImage(data: imageData as Data) {
                return image
            }
        }
        return nil
    }
    
}

extension Entry {
    
    var entryDate: Date {
        return self.date as Date
    }
    
    @objc var monthYear: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self.date as Date)
    }
    
}

extension Entry {
    //Exact location from selected latitude/longitude
    var locationPoint: CLLocation? {
        if let latitude = self.latitude, let longitude = self.longitude {
            if let latDouble = Double(latitude), let longDouble = Double(longitude) {
                return CLLocation(latitude: latDouble, longitude: longDouble)
            }
        }
        return nil
    }
}
