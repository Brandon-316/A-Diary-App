//
//  Moods.swift
//  A Diary App
//
//  Created by Brandon Mahoney on 2/6/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit

enum Moods {
    case bad
    case average
    case good
    
    var image: UIImage {
        switch self {
            case .bad: return #imageLiteral(resourceName: "BadFace")
            case .average: return #imageLiteral(resourceName: "AverageFace")
            case .good: return #imageLiteral(resourceName: "HappyFace")
        }
    }
    
    var moodDescriptor: String {
        switch self {
        case .bad: return "Bad"
        case .average: return "Average"
        case .good: return "Good"
        }
    }
}
