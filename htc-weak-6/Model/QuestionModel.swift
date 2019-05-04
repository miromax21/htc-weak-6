//
//  QuestionModel.swift
//  htc-weak-6
//
//  Created by maxim mironov on 30/04/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//

import Foundation

struct ServerDataModel: Codable {
    var has_more: Bool
    var quota_max: Int
    var quota_remaining: Int
    var items: [ItemsModel]
}
struct ItemsModel:Codable {
    var owner:ItemsOwnerModel
    var is_accepted:Bool
    var score:Int
    var last_activity_date:Int
    var creation_date:Int
    var answer_id:Int
    var question_id:Int
}


struct ItemsOwnerModel : Codable{
    var reputation: Int
    var user_id: Int
    var user_type: String
    var profile_image: String
    var display_name: String
    var link: String
}
