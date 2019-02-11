//
//  Entry+CoreDataProperties.swift
//  A Diary App
//
//  Created by Brandon Mahoney on 1/26/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//
//

import Foundation
import UIKit
import CoreData


//@objc(Entry)
public class Entry: NSManagedObject {}


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        return request
    }

    @NSManaged public var date: NSDate
    @NSManaged public var imageData: NSData?
    @NSManaged public var location: String?
    @NSManaged public var mood: String?
    @NSManaged public var text: String

}


extension Entry {
    static var entityName: String {
        return String(describing: Entry.self)
    }
    
    
    @nonobjc class func with(text: String, date: Date, image: UIImage?, mood: Moods?, location: String?, in context: NSManagedObjectContext) -> Entry {
        let entry = NSEntityDescription.insertNewObject(forEntityName: Entry.entityName, into: context) as! Entry
        
        entry.text = text
        entry.date = date as NSDate
        
        if let image = image {
            entry.imageData = image.jpegData(compressionQuality: 1.0)! as NSData
        }
        
        if let mood = mood {
            entry.mood = mood.moodDescriptor
        }
        
        if let location = location {
            entry.location = location
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
    var dateStringWithYear: String {
        return getDateString(withYear: true)
    }
    
    var dateStringWithoutYear: String {
        return getDateString(withYear: false)
    }
    
    var dateHeaderString: String {
        let date = self.date as Date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        return formatter.string(from: date)
    }
    
    
    func getDateString(withYear isYear: Bool) -> String {
        let date = self.date as Date
        let formatter = DateFormatter()
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .year], from: date)
        
        formatter.dateFormat = "EEEE"
        let day = formatter.string(from: date as Date)
        
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: date as Date)
        
        var dayNum  = "\(anchorComponents.day!)"
        switch (dayNum) {
        case "1" , "21" , "31":
            dayNum.append("st")
        case "2" , "22":
            dayNum.append("nd")
        case "3" ,"23":
            dayNum.append("rd")
        default:
            dayNum.append("th")
        }
        
        if isYear {
            let year = "\(anchorComponents.year!)"
            return "\(day) \(dayNum) \(month) \(year)"
        } else {
            return "\(day) \(dayNum) \(month)"
        }
    }
}
