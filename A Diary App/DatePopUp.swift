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
    
    //Call back for saving new date
    var onSave: ((_ date: Date) -> ())?
    
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDatePicker()
        
        popUpView.layer.cornerRadius = 6
        popUpView.layer.masksToBounds = true
        
        
    }
    
    
    //MARK: Methods
    func setUpDatePicker() {
        //Set up datePicker
        if let date = entryDate {
            datePicker.date = date
            return
        }
    }
    
    //MARK: Actions
    @IBAction func update(_ sender: Any) {
        
        self.onSave?(datePicker.date)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
