//
//  ViewController.swift
//  htc-weak-6
//
//  Created by maxim mironov on 30/04/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        DataModelFunctions.getQuestionsData(url: APP_CONSTANTS.GITHUB_URL) {
            for project in DataModel.data!.items{
                self.tableView.reloadData()
            }
        }
    }
}
extension ViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return DataModel.data?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let model = DataModel.data?.items[indexPath.row]
        cell.textLabel?.text = "\(model?.question_id)" ?? ""
        return cell
    }
    
    
}
