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
    var items = [ItemModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isEditing = false
        let bbItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(clickButton))
        self.navigationItem.rightBarButtonItem = bbItem
        loadData(tag: "swift")
    }
    
    func loadData(tag: String)  {
        let activityIndicator = ActivityIndicator(view: tableView)
        activityIndicator.showActivityIndicator()
        let urlSesion = URLSessionApiSrevice()
        urlSesion.getQuestionsAlamofire(tag: tag) { (data) in
            self.items = data
            self.tableView.reloadData()
            activityIndicator.stopActivityIndicator()
        }
//        DataModelFunctions.getQuestionsData(url: APP_CONSTANTS.GITHUB_URL + "&tagged=\(queryParam)") {sucsess in
//            if (sucsess){
//                self.tableView.reloadData()
//            }
//            activityIndicator.stopActivityIndicator()
//        }
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
extension ViewController: UITableViewDataSource, UITableViewDelegate, SatTagDelegate {
    
    func setTag(tag: String) {
        loadData(tag: tag)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableviewCell.identifier) as! QuestionTableviewCell
        let model = self.items[indexPath.row]
        cell.initCell(param:model)
        return cell
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        self.questionIndex = indexPath.row
////        self.performSegue(withIdentifier: "ShowDetailsControllerSeque", sender: nil)
////        let detailControllerViewController = ShowDetailsController()
////        detailControllerViewController.answers = self.items[indexPath.row].answers
//       // detailControllerViewController.answers = [Answer]() // self.items[indexPath.row].answers)
//       // detailControllerViewController.questionIndes = indexPath.row
//        let detailControllerViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowDetailsController") as? ShowDetailsController
//        detailControllerViewController?.answers = self.items[indexPath.row].answers
//        self.navigationController?.pushViewController(detailControllerViewController!, animated: true)
//        
//     //   navigationController?.pushViewController(detailControllerViewController, animated: true)
//    }
    
}
