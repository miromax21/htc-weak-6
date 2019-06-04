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
        
        
        let pinchRecognizer = UIPinchGestureRecognizer()
        pinchRecognizer.addTarget(self, action: #selector(handlePinchGesture(_:)))
        
        self.view.addGestureRecognizer(rightSwipeRecognizer)
        self.view.addGestureRecognizer(pinchRecognizer)
    }
    
    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            guard let url = Bundle.main.url(forResource: "rington", withExtension: "mp3") else { return }
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            player?.play()
            let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
                 self.player?.pause()
            }
        }
    }
    // Example Tabbar 5 pages
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        goToSetTag()
    }
    
    func loadData(tagIndex: Int?, from: Int = 1, count: Int = 50)  {
        self.items = []

        activityIndicator.startAnimating()
        
        self.tableView.alpha = 0
        self.urlSession.getQuestions { [weak self] (data) in
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let maxPosition = scrollView.contentInset.top + scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.bounds.size.height;
        let currentPosition = scrollView.contentOffset.y + self.topLayoutGuide.length;
        
        if (currentPosition >= maxPosition){
            self.urlSession.next { (newItems) in
                guard let newItems = newItems else {return}
                var addIndex = self.items.count - 1
                self.items.insert(contentsOf:newItems, at: addIndex)
        
                // Better than reload the whole tableview
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: addIndex, section: 0)], with: .bottom)
                self.tableView.endUpdates()
//                self.tableView.beginUpdates()
//                self.items.insert(contentsOf:newItems, at: self.items.count)
//             //   let insertIndexPaths = Array(self.items.count...self.items.count + newItems.count - 1).map {IndexPath(item: $0, section: 0) }
//                self.tableView.insertRows(at: [IndexPath.init(row: newItems.count, section: 0)], with: .automatic)
//              //  self.tableView.insertRows(at: insertIndexPaths, with: .automatic)
//                self.tableView.endUpdates()
            }
        }
    }

}

 
extension ViewController: SatTagDelegate{
    
    func setTag(tagIndex: Int) {
        loadData(tagIndex: tagIndex)
    }
}
