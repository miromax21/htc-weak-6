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

struct ItemModel: Codable {
    var owner: ItemOwnerModel
  //  var is_answered: Bool
    var answerCount: Int
    var score: Int?
    var title: String
    var lastEditDate: Int?
    var creationDate: Int
//    var question_id:Int
    var answers: [Answer]?
    
    enum CodingKeys: String, CodingKey {
        case owner
        case answerCount = "answer_count"
        case score
        case title
        case lastEditDate = "last_edit_date"
        case creationDate = "creation_date"
        case answers
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.owner = try container.decode(ItemOwnerModel.self, forKey: .owner)
        self.answerCount = try container.decode(Int.self, forKey: .answerCount)
        self.score = try? container.decode(Int.self, forKey: .score)
        self.title = try container.decode(String.self, forKey: .title)
        self.lastEditDate = try? container.decode(Int.self, forKey: .lastEditDate)
        self.creationDate = try container.decode(Int.self, forKey: .creationDate)
        self.answers = try? container.decode([Answer].self, forKey: .answers)

    }
}
struct Answer: Codable  {
    var title: String
    var owner: ItemOwnerModel
}
struct ItemOwnerModel : Codable{
    var displayName: String?
    var link: String?
    var reputation: Int

    enum CodingKeys : String, CodingKey {
        case displayName = "display_name"
        case link
        case reputation
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.displayName = try? container.decode(String.self, forKey: CodingKeys.displayName)
        self.link = try? container.decode(String.self, forKey: CodingKeys.link)
        self.reputation = try container.decode(Int.self, forKey: CodingKeys.reputation)
    }
}

extension Answer:Comparable{
    static func < (lhs: Answer, rhs: Answer) -> Bool {
        return lhs.owner.reputation < rhs.owner.reputation
    }
    
    static func == (lhs: Answer, rhs: Answer) -> Bool {
        return lhs.owner.reputation  == rhs.owner.reputation
    }
    
    
}
