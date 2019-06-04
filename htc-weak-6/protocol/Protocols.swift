//
//  protocols.swift
//  htc-weak-6
//
//  Created by maxim mironov on 14/05/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//

import Foundation
protocol GetQuestionsProtocol {
    func getQuestions(completion: @escaping ([ItemModel]) -> ())
    func next(completion: @escaping ([ItemModel]?) -> ())
}
