//
//  QuestionModel.swift
//  htc-weak-6
//
//  Created by maxim mironov on 30/04/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//

import Foundation

struct ServerDataModel: Codable {
    var items: [ItemModel]
}
struct ItemModel:Codable {
    var owner:ItemOwnerModel
    var is_answered: Bool
    var answer_count: Int
    var score: Int
    var title: String
    var last_edit_date: Int?
    var creation_date: Int
    var question_id:Int
    var answers: [Answer]?
}
struct Answer:Codable  {
    var title: String
}
struct ItemOwnerModel : Codable{
    var display_name: String?
    var link: String?

}
