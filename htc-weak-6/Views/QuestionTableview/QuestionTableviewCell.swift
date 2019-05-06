//
//  QuestionTableviewCell.swift
//  htc-weak-6
//
//  Created by maxim mironov on 05/05/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//

import UIKit
class QuestionTableviewCell: UITableViewCell {
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var answersCount: UILabel!
    @IBOutlet weak var editDate: UILabel!
    
    func initCell(param:ItemModel) {
        question.text  = param.title
        author.text = param.owner.display_name
        answersCount.text = "\(param.answer_count)"
        editDate.text = (param.last_edit_date != nil) ? "\(Date.init(timeIntervalSince1970: TimeInterval(param.last_edit_date!)).mediumDate())" : "\(Date.init(timeIntervalSince1970: TimeInterval(param.creation_date)).mediumDate())"
    }
}
