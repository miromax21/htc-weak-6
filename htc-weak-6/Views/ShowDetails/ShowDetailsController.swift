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
    var funct : ((String) -> Void)?
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var detailTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let index = questionIndes, let question = DataModel.data?.items[index]{
//         //   self.navBar.topItem?.title = question.title
//            answers = question.answers
//        }
    }
//    func setParams(items:[Answer]?)  {
//        if items == nil{
//            self.answers = [Answer]()
//        }
//        else{
//            self.answers = items
//        }
//
//        self.answers = items ?? [Answer]()
//        detailTable.reloadData()
//    }
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ShowDetailsController:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.row == 0{
            cell.backgroundColor = .yellow
        }
        cell.textLabel?.text = answers?[indexPath.row].title
        return cell
    }
    
}
