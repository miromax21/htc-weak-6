//
//  QuestionTableviewCell.swift
//  htc-weak-6
//
//  Created by maxim mironov on 05/05/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//

import UIKit
class QuestionTableviewCell: UITableViewCell {
    @IBOutlet weak var question: UILabel?
    
    func initCell(param:String) {
        question?.text  = param
    }
}
