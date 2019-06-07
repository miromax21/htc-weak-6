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
        author.text = param?.owner?.displayName
        answersCount.text = param?.owner?.reputation != nil ?   String(describing: param!.owner!.reputation!) : "0"
        editDate.text = param?.creationDate != nil ? "\(Date.init(timeIntervalSince1970: TimeInterval(param!.creationDate!)).mediumDate())" : ""
        answertext.text = param?.body
        
        
    }
    
}
