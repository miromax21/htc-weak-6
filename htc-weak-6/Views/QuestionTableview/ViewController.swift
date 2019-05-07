//
//  ViewController.swift
//  htc-weak-6
//
//  Created by maxim mironov on 30/04/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let queryTypeArray: [String] = ["swift", "ios", "xcode", "cocoa-touch", "iphone"]
    var questionIndex : Int = 0;
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        tableView.isEditing = false
        let bbItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(clickButton))
        self.navigationItem.rightBarButtonItem = bbItem
        loadData(queryParam: "")
    }
    func loadData(queryParam:String)  {
        let activityIndicator = ActivityIndicator(view:tableView)
        let queryParam = (queryParam == "") ? queryTypeArray[0] : queryParam
        activityIndicator.showActivityIndicator()
        DataModelFunctions.getQuestionsData(url: APP_CONSTANTS.GITHUB_URL + "&tagged=\(queryParam)") {sucsess in
            if (sucsess){
                self.tableView.reloadData()
            }
            activityIndicator.stopActivityIndicator()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SetTagViewControllerSeque" {
            let vc : SetTagViewController = segue.destination as! SetTagViewController
            vc.delegate = self
            vc.pickerData = queryTypeArray
        }else if segue.identifier == "ShowDetailsControllerSeque"{
            let vc : ShowDetailsController = segue.destination as! ShowDetailsController
            vc.questionIndes = self.questionIndex
        }
    }
    @objc func clickButton()  {
        self.tableView.isEditing = !self.tableView.isEditing
    }
}
extension ViewController:UITableViewDataSource, UITableViewDelegate,SatTagDelegate{
    func setTag(tagId: Int) {
        loadData(queryParam: queryTypeArray[tagId])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return DataModel.data?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableviewCell.identifier) as! QuestionTableviewCell
        let model = DataModel.data?.items[indexPath.row]
        cell.initCell(param:model!)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.questionIndex = indexPath.row
        self.performSegue(withIdentifier: "ShowDetailsControllerSeque", sender: nil)
    }
    
}
