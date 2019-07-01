//
//  ShowDetailsController.swift
//  htc-weak-6
//
//  Created by maxim mironov on 05/05/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//

import UIKit
class ShowDetailsController: UIViewController {
    var question: ItemModel?
    var questionIndes:Int?
    var answers: [Answer] = []
    var questionAuthor: ItemOwnerModel?
    var aquestionTitle: String? = ""

    @IBOutlet weak var detailTable: UITableView!
//    @IBOutlet weak var author: UILabel!
//    @IBOutlet weak var date: UILabel!
//    @IBOutlet weak var votes: UILabel!
//    @IBOutlet weak var questionLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = aquestionTitle
    }
    func setUpParms(question:ItemModel){
        if let answers = question.answers{
            self.answers = answers
        }
        self.questionAuthor = question.owner
        self.aquestionTitle = question.title
        self.answers.insert(Answer(body: question.title, owner: question.owner,creationDate: question.creationDate), at: 0)
    }


    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ShowDetailsController:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableviewCell.identifier) as! AnswerTableviewCell
        let model = answers[indexPath.row]
        cell.configureCell(param: model,selected:self.questionAuthor?.userId == model.owner?.userId )
        cell.accessoryType = (model.owner?.isAccepted ?? false) ? .checkmark : .none
        cell.configureCell(param: model, selected: indexPath.row == 0)
        return cell
    }
    
}
