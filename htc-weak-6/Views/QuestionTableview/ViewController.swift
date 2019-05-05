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
        let param = queryParam == "&tagged=ios" ? queryParam : "&tagged=\(queryParam)"
        DataModelFunctions.getQuestionsData(url: APP_CONSTANTS.GITHUB_URL + param) {sucsess in
            if (sucsess){
                self.tableView.reloadData()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setTagSeque" {
            let vc : SetTagViewController = segue.destination as! SetTagViewController
            vc.delegate = self
            vc.pickerData = queryTypeArray
        }
    }
    @objc func clickButton()  {
        self.tableView.isEditing = !self.tableView.isEditing
    }
}
extension ViewController:UITableViewDataSource, UITableViewDelegate,SatTagDelegate{
    func setTag(tag: String) {
        print(tag)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return DataModel.data?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! QuestionTableviewCell
        let model = DataModel.data?.items[indexPath.row]
        cell.initCell(param:model!)
        return cell
//        let cell = UITableViewCell()
//        let model = DataModel.data!.items[indexPath.row]
//        cell.textLabel?.text = "\(Date(timeIntervalSince1970: TimeInterval(model.creation_date)))"
//        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc  = ShowDetailsController.getInstance() as! ShowDetailsController
        present(vc, animated: true)
    }
    
}
