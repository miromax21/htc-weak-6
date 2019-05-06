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
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: nil)
        let bbItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(clickButton))
        self.navigationItem.rightBarButtonItem = bbItem
        if let index = questionIndes{
            let question = DataModel.data?.items[index]
            print(question)
        }
        
    }
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @objc func clickButton()  {
        print("<#T##items: Any...##Any#>")
    }
}
