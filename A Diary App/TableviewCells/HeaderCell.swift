//
//  HeaderCell.swift
//  A Diary App
//
//  Created by Brandon Mahoney on 1/29/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import UIKit


class HeaderCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCell(with title: String) {
        titleLabel.text = title
    }
    
}
