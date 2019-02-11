//
//  EventDatePopUp.swift
//
//  Created by Brandon Mahoney on 8/1/18.
//  Copyright © 2018 William Mahoney. All rights reserved.
//

import Foundation
import UIKit


class DatePopUp: UIViewController {
    
    var currentDate = ""
    var entryDate: Date?
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up datePicker
        if let date = entryDate {
            datePicker.date = date
        }
        
        if currentDate.isEmpty == false {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
            //            let dateString = formatter.string(from: picker.date)
            let date = formatter.date(from: currentDate)
            datePicker.date = date!
        }
        
        popUpView.layer.cornerRadius = 6
        popUpView.layer.masksToBounds = true
        
        
    }
    
    
    //MARK: Methods
    
    //MARK: Actions
    @IBAction func update(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotifications().dateSaved, object: datePicker.date)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
