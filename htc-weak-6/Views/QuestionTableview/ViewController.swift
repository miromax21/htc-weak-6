//
//  ViewController.swift
//  htc-weak-6
//
//  Created by maxim mironov on 30/04/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//
import UIKit
import AVFoundation
class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var items = [ItemModel]()
    var urlSession: GetQuestionsProtocol!
    var tag: String = "swift"
    var property = Property()
    var player: AVPlayer?
    
    fileprivate func addTagButton() {
        let setTagBarButton = UIBarButtonItem(title: NSLocalizedString("set tag", comment: "set tag bar button item text"), style: .done, target: self, action: #selector(goToSetTag))
        self.navigationItem.leftBarButtonItem = setTagBarButton
        self.navigationItem.title = property.tags[0]
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addTagButton()
        setGestures()
        self.urlSession = AlamofireApiServices.init(tag: property.tags[0], pageCount: 10)
        //self.urlSession = URLSessionApiSrevices.init(tag:  property.tags[0], pageCount: 10)
        loadData(tagIndex: nil)
        
    }
    func setGestures(){
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        rightSwipeRecognizer.direction = UISwipeGestureRecognizer.Direction.right
        
        let downSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(downSpiped))
        downSwipeRecognizer.direction = UISwipeGestureRecognizer.Direction.down
        
        let pinchRecognizer = UIPinchGestureRecognizer()
        pinchRecognizer.addTarget(self, action: #selector(handlePinchGesture(_:)))
        
        self.view.addGestureRecognizer(rightSwipeRecognizer)
        self.view.addGestureRecognizer(pinchRecognizer)
        self.view.addGestureRecognizer(downSwipeRecognizer)
    }
    
    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            guard let url = Bundle.main.url(forResource: "rington", withExtension: "mp3") else { return }
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            player?.play()
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
                 self.player?.pause()
            }
        }
    }
    // Example Tabbar 5 pages
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        goToSetTag()
    }
    
    @objc func downSpiped(_ gesture: UISwipeGestureRecognizer) {
        loadData(tagIndex: 0)
    }
    
    func loadData(tagIndex: Int?)  {
        self.items = []

        activityIndicator.startAnimating()
        self.tableView.alpha = 0
        self.urlSession.getQuestions(tag: self.property.tags[tagIndex ?? 0]) { [weak self] (data) in
            guard let strongSelf = self else {return}
            let appDelegate = UIApplication.shared.delegate as! ApDelegate
            appDelegate.tagIndex =  tagIndex ?? 0
            strongSelf.items = data
            strongSelf.tableView.reloadData()
            strongSelf.navigationItem.title = strongSelf.property.tags[appDelegate.tagIndex]
            strongSelf.activityIndicator.stopAnimating()
            UIView.animate(withDuration: 1.5, animations: {
                strongSelf.tableView.alpha = 1
            })
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
       return self.items.count + 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ShowDetailsController.getInstance() as! ShowDetailsController
        let model = self.items[indexPath.row]
        vc.setUpParms(answers: model.answers, questionTitle: model.title, questionAsFirstAmongAnswers: Answer(body: model.title, owner: model.owner,creationDate: model.creationDate))
    
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == self.items.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableviewCell.identifier) as! QuestionTableviewCell
        let model = self.items[indexPath.row]
        cell.configureCell(param:model)
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let maxPosition = scrollView.contentInset.top + scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.bounds.size.height;
        let currentPosition = scrollView.contentOffset.y + self.topLayoutGuide.length;
        activityIndicator.startAnimating()
        if (currentPosition >= maxPosition){
            self.urlSession.next { (newItems) in
                guard let newItems = newItems else {return}
                self.items += newItems
                
                let indexPaths = (self.items.count - newItems.count ..< self.items.count).map { IndexPath(row: $0, section: 0) }
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: indexPaths, with: .automatic)
                self.tableView.endUpdates()
                self.activityIndicator.stopAnimating()
            }
        }
    }

}

extension ViewController: SatTagDelegate{
    
    func setTag(tagIndex: Int) {
        loadData(tagIndex: tagIndex)
    }
}
