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
  //  var is_answered: Bool
    var answerCount: Int
    var score: Int?
    var title: String
    var lastEditDate: Int?
    var creationDate: Int
//    var question_id:Int
//    var answers: [Answer]?
    
    enum CodingKeys: String, CodingKey {
        case owner
        case answerCount = "answer_count"
        case score
        case title
        case lastEditDate = "last_edit_date"
        case creationDate = "creation_date"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.owner = try container.decode(ItemOwnerModel.self, forKey: .owner)
        self.answerCount = try container.decode(Int.self, forKey: .answerCount)
        self.score = try? container.decode(Int.self, forKey: .score)
        self.title = try container.decode(String.self, forKey: .title)
        self.lastEditDate = try? container.decode(Int.self, forKey: .lastEditDate)
        self.creationDate = try container.decode(Int.self, forKey: .creationDate)

    }
}
struct Answer:Codable  {
    var title: String
}
struct ItemOwnerModel : Codable{
    var displayName: String?
    var link: String?
    enum CodingKeys : String, CodingKey {
        case displayName = "display_name"
        case link
    }
}
