//
//  ShowDetailsController.swift
//  htc-weak-6
//
//  Created by maxim mironov on 05/05/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//

import UIKit
class ShowDetailsController: UIViewController {
    
    var questionIndes:Int?
    var answers:[Answer]? = [Answer]()
    var aquestionTitle: String? = ""
    var authorModel: String? = ""
    var scores:Int? = 0
    var dateModel: Int? = 0
    var funct : ((String) -> Void)?
    
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var votes: UILabel!
    @IBOutlet weak var questionLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = aquestionTitle
    }
    func setUpParms(answers:[Answer]?, questionTitle: String?, questionAsFirstAmongAnswers:Answer){
        if answers != nil{
            self.answers = answers
        }
        self.aquestionTitle = questionTitle
        self.answers!.insert(questionAsFirstAmongAnswers, at: 0)
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ShowDetailsController:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableviewCell.identifier) as! AnswerTableviewCell
        let model = answers?[indexPath.row]
        cell.configureCell(param: model)
        
        cell.accessoryType = (model?.owner?.isAccepted ?? false) ? .checkmark : .none
        if indexPath.row == 0{
            cell.backgroundColor = .yellow
        }
        return cell
    }
    
}
