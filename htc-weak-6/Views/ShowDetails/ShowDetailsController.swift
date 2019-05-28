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
    var funct : ((String) -> Void)?
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var detailTable: UITableView!
    
    @IBOutlet weak var questionLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = aquestionTitle
       // self.answers = self.answers?.sorted(by: >)
        questionLable.text = aquestionTitle
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
        
        cell.configureCell(param: answers?[indexPath.row])
//
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "dsd")
//        if indexPath.row == 0{
//            cell.backgroundColor = .yellow
//        }
//        cell.textLabel?.text = answers?[indexPath.row].body
//        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
}
