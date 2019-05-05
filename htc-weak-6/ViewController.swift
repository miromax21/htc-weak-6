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
        let param = queryParam == "" ? queryParam : "&\(queryParam)"
        DataModelFunctions.getQuestionsData(url: APP_CONSTANTS.GITHUB_URL + param) {sucsess in
            if (sucsess){
                self.tableView.reloadData()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "setTagSeque" {
            let vc : SetTagViewController = segue.destination as! SetTagViewController
            vc.delegate = self
            vc.pickerData = queryTypeArray
        }
//        else if  segue.identifier == "ShowDetailsController" {
//            let storyboard = UIStoryboard(name: String(describing: ShowDetailsController.self), bundle: nil)
//            let vc = storyboard.instantiateInitialViewController() as! ShowDetailsController
//            navigationController?.pushViewController(vc, animated: true)
//        }
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
        let cell = UITableViewCell()
        let model = DataModel.data!.items[indexPath.row]
        cell.textLabel?.text = "\(Date(timeIntervalSince1970: TimeInterval(model.creation_date)))"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc  = ShowDetailsController.getInstance() as! ShowDetailsController
        present(vc, animated: true)
//        let storyboard = UIStoryboard(name: String(describing: ShowDetailsController.self), bundle: nil)
//        let vc = storyboard.instantiateInitialViewController() as! ShowDetailsController
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ShowDetailsController") as! ShowDetailsController
//        navigationController?.pushViewController(nextViewController, animated: true)
////        let storyboard = UIStoryboard(name: String(describing: "Main"), bundle: nil)
//        let vc = storyboard.instantiateInitialViewController() as! ShowDetailsController
//       // let trip = Data.tripModels[indexPath.row]
//      //  vc.tripId = trip.id
//        navigationController?.pushViewController(vc, animated: true)
        
//        self.questionIndex = indexPath.row
//        self.performSegue(withIdentifier: "ShowDetailsController", sender: self)
    }
    
}
