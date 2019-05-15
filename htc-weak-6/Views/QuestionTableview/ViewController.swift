//
//  ViewController.swift
//  htc-weak-6
//
//  Created by maxim mironov on 30/04/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var items = [ItemModel]()
    var urlSession:GetQuestionsProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        tableView.isEditing = false
        let bbItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(clickButton))
        self.navigationItem.rightBarButtonItem = bbItem
        loadData(tag: "swift")
        
    }
    
    func loadData(tag: String)  {
        self.urlSession = AlamofireApiServices()
//        self.urlSession = URLSessionApiSrevices()
        activityIndicator.startAnimating()
        
        self.tableView.alpha = 0
        self.urlSession.getQuestions(tag: tag) { (data) in
            self.items = data
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            UIView.animate(withDuration: 1.5, animations: {
                self.tableView.alpha = 1
            })
        }
    }
    
    
    @objc func clickButton()  {
        self.tableView.isEditing = !self.tableView.isEditing
    }
    @IBAction func goToChangeTag(_ sender: Any) {
        let storyboard = UIStoryboard(name: String(describing: SetTagViewController.self), bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! SetTagViewController
        vc.delegate = self
        self.present(vc, animated: true)
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
        if model.answerCount > 0 {
            cell.accessoryType = UITableViewCell.AccessoryType.detailDisclosureButton
        }
        cell.initCell(param:model)
        return cell
    }
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: String(describing: ShowDetailsController.self), bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! ShowDetailsController
        let model = self.items[indexPath.row]
        vc.answers = model.answers
        vc.aquestionTitle = model.title
        self.navigationController?.pushViewController(vc, animated: true)
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
