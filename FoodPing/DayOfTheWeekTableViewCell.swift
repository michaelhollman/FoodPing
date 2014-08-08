//
//  DayOfTheWeekTableViewCell.swift
//  FoodPing
//
//  Created by Michael Hollman on 8/7/14.
//  Copyright (c) 2014 Michael Hollman. All rights reserved.
//

import UIKit

class DayOfTheWeekTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDayLetter: UILabel?
    @IBOutlet weak var labelFood: UILabel?

    var dayLetter: String = "" {
        didSet {
            labelDayLetter?.text = dayLetter
        }
    }

    var food: String = "" {
        didSet {
            labelFood?.text = food
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // iPads are stupid
        backgroundColor = UIColor.clearColor()
    }
}
