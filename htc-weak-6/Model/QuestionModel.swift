//
//  QuestionModel.swift
//  htc-weak-6
//
//  Created by maxim mironov on 30/04/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ServerData: Codable {
    var has_more: Bool
    var quota_max: Int
    var quota_remaining: Int
    var items: [Items]
}
struct Items:Codable {
    var owner:Owner
    var is_accepted:Bool
    var score:Int
    var last_activity_date:Int
    var creation_date:Int
    var answer_id:Int
    var question_id:Int
}


struct Owner : Codable{
    var reputation: Int
    var user_id: Int
    var user_type: String
    var profile_image: String
    var display_name: String
    var link: String
}


struct QuestionModel:Codable {
    
    var user_type : String
}
//
//protocol JSONDecdable {
//    init?(JSON:Any)
//}
//extension QuestionModel: JSONDecdable{
//    
//    init?(JSON: Any) {
//        guard let JSON = JSON as? [String:Any] else { return nil}
//        guard let text = JSON["text"] as? String else {return nil}
//        self.text = text
//    }
//}
