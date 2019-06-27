//
//  protocols.swift
//  htc-weak-6
//
//  Created by maxim mironov on 14/05/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//

import Foundation
protocol GetQuestionsProtocol {
        func getQuestions(tag:String, completion: @escaping ([ItemModel]?, String?) -> ())
        func next(completion: @escaping ([ItemModel]?, String?) -> ())
        func getGuestionse(tag:String, completion: @escaping (_ responce:Questionanswer) -> ())
}
enum Questionanswer{
    case error(items:[ItemModel]?, errorMessage:[String])
    case success(items:[ItemModel]?)
}


