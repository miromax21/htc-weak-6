//
//  SetTagController.swift
//  htc-weak-6
//
//  Created by maxim mironov on 04/05/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//

import UIKit
protocol SatTagDelegate {
    func setTag(tagId : Int)
}
class SetTagViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var setTagButton: UIButton!
    var delegate : SatTagDelegate?
    var pickerData: [String] = [String]()
    private var tagId: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    @IBAction func SetTag(_ sender: Any) {
        delegate?.setTag(tagId: tagId)
        dismiss(animated: true)
    }
}

extension SetTagViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.tagId  = row
    }
    
    
    
}
