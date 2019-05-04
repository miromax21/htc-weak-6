//
//  SetTagController.swift
//  htc-weak-6
//
//  Created by maxim mironov on 04/05/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//

import UIKit
protocol SatTagDelegate {
    func setTag(tag : String)
}
class SetTagViewController: UIViewController {
    
    @IBOutlet weak var set: UIButton!
    var delegate : SatTagDelegate?
    @IBAction func SetTag(_ sender: Any) {
        if delegate != nil {
            delegate?.setTag(tag: "asdasdasdsd")
            dismiss(animated: true)
        }
    }
}
