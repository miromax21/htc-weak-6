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
    var urlSession: GetQuestionsProtocol!
    var tag: String = "swift"
    var property = Property()
    
    
    fileprivate func addTagButton() {
        let setTagBarButton = UIBarButtonItem(title: NSLocalizedString("set tag", comment: "set tag bar button item text"), style: .done, target: self, action: #selector(goToSetTag))
        self.navigationItem.leftBarButtonItem = setTagBarButton
        self.navigationItem.title = property.tags[0]
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addTagButton()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        self.urlSession = AlamofireApiServices()
        //        self.urlSession = URLSessionApiSrevices()
        loadData(tagIndex: nil)
        
    }
    
    // Example Tabbar 5 pages
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        goToSetTag()
    }
    
    func loadData(tagIndex: Int?, from: Int = 1, count: Int = 50)  {
        self.items = []

        activityIndicator.startAnimating()
        
        self.tableView.alpha = 0
        self.urlSession.getQuestions(tag: self.property.tags[tagIndex ?? 0],fromPage: self.property.pageNumber, pagesCount: 10) { (data) in
            let appDelegate = UIApplication.shared.delegate as! ApDelegate
            appDelegate.tagIndex =  tagIndex ?? 0
            self.items = data
            self.tableView.reloadData()
            self.navigationItem.title = self.property.tags[appDelegate.tagIndex]
            self.activityIndicator.stopAnimating()
            UIView.animate(withDuration: 1.5, animations: {
                self.tableView.alpha = 1
            })
        }
    }
    
    func fetchData(tagIndex: Int?, from: Int = 1, count: Int = 50){
        let appDelegate = UIApplication.shared.delegate as! ApDelegate
        self.urlSession.getQuestions(tag: self.property.tags[appDelegate.tagIndex],fromPage: self.property.pageNumber, pagesCount: 10) { (data) in
            self.items = data
            let indexPaths = (self.items.count ..< self.items.count + data.count).map { IndexPath(row: $0, section: 0) }
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: indexPaths, with: .bottom)
            self.tableView.endUpdates()
            
        }
    }
    
    @objc func goToSetTag()  {
        let storyboard = UIStoryboard(name: String(describing: SetTagViewController.self), bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! SetTagViewController
        vc.delegate = self
        vc.pickerData = self.property.tags
       // vc.pickerView.selectedRow(inComponent: ApDelegate().tagIndex)
        self.present(vc, animated: true)
        
    }
}

// MARK: TableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.items.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ShowDetailsController.getInstance() as! ShowDetailsController
        let model = self.items[indexPath.row]
        vc.answers = model.answers
        vc.aquestionTitle = model.title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableviewCell.identifier) as! QuestionTableviewCell
        let model = self.items[indexPath.row]
        cell.configureCell(param:model)
        return cell
    }
}

extension ViewController: SatTagDelegate{
    
    func setTag(tagIndex: Int) {
        loadData(tagIndex: tagIndex)
    }
}
