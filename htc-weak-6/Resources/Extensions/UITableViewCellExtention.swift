//
//  UITableViewCellExtention.swift
//  htc-weak-6
//
//  Created by maxim mironov on 06/05/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//

import UIKit
extension UITableViewCell{
    class var identifier:String{
        return String(describing: self)
    }
}
