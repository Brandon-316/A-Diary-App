//
//  AlertUser.swift
//  TBA-SA
//
//  Created by Brandon Mahoney on 4/3/18.
//  Copyright © 2018 William Mahoney. All rights reserved.
//

import Foundation
import UIKit

class AlertUser {
    
    //MARK: - Alert User
    //Alert for UITableViewController
    func generalAlert(title: String, message: String, vc: UITableViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    //Alert for UIViewController
    func generalAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    
}
