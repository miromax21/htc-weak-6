//
//  Alamofire.swift
//  htc-weak-6
//
//  Created by maxim mironov on 14/05/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//

import Foundation
import Alamofire
class AlamofireApiServices : GetQuestionsProtocol {
    var tag : String = ""
    var pageNumber : Int = 1
    var pageCount:Int
    var inProces:Bool = false
    var hasMore:Bool = false
    init(tag:String, pageCount: Int = 10) {
        self.tag = tag
        self.pageCount = pageCount
    }
    
    fileprivate let githubUrl = "https://api.stackexchange.com/2.2/questions?order=desc&sort=activity&site=stackoverflow&filter=!7qeDKpT6lDlJdv7Plyc8cHxkdcsS4Pgw(H"
    
    func getQuestions(tag:String, completion: @escaping ([ItemModel]) -> ()){
        self.tag = tag
        inProces = true
        DispatchQueue.global(qos: .background).async{
            let url = URL(string: self.githubUrl + "&tagged=\(self.tag)&page=\(self.pageNumber)&pagesize=\(self.pageCount)")!
            Alamofire.request(url).responseJSON { response in
                self.inProces = false
                completion(self.convertDataToModel(response: response))
            }
        }
    }
    
    func next(completion: @escaping ([ItemModel]?) -> ()) {
        guard !inProces || !hasMore else { return }
        pageNumber += 1
        return getQuestions(tag: self.tag, completion: completion)
    }
    
    func convertDataToModel(response:DataResponse<Any>) -> [ItemModel]{
        guard response.result.isSuccess,  let responceData = response.data else{ return [ItemModel]()}
        guard  let data = try? JSONDecoder().decode(ServerDataModel.self, from: responceData), let items = data.items else { return [ItemModel]() }
        self.hasMore = data.has_more
        return items
    }
}
