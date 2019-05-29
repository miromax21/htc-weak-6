//
//  AnswerTableviewCell.swift
//  htc-weak-6
//
//  Created by maxim mironov on 28/05/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//

import UIKit
class AnswerTableviewCell: UITableViewCell {
    @IBOutlet weak var answer: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var answersCount: UILabel!
    @IBOutlet weak var editDate: UILabel!
    @IBOutlet weak var answertext: UILabel!
    
    func configureCell(param: Answer?) {
        author.text = "author"
        answersCount.text = "3232"
        editDate.text = "\(Date.init(timeIntervalSinceNow: 22).mediumDate())"
        answertext.text = param?.body
    }
    
}
