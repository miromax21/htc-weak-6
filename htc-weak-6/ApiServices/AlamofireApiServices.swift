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
    
    fileprivate let githubUrl = "https://api.stackexchange.com/2.2/questions?order=desc&sort=activity&site=stackoverflow&filter=!41)ayTHRdCp0rZZJm"
    func getQuestions(tag: String, fromPage: Int, pagesCount: Int, completion: @escaping ([ItemModel]) -> ()){
        DispatchQueue.global(qos: .background).async{
             let url = URL(string: self.githubUrl + "&tagged=\(tag)&page=\(fromPage)&pagesize=\(pagesCount)")!
            Alamofire.request(url).responseJSON { response in
                guard response.result.isSuccess,  let responceData = response.data else{
                    completion([ItemModel]())
                    return
                }
                var data: ServerDataModel? = nil
                do {
                    data = try JSONDecoder().decode(ServerDataModel.self, from: responceData)
                } catch {
                    print(error)
                }
                guard data != nil, let items = data?.items else{
                    completion([ItemModel]())
                    return
                }
                completion(items)
                
            }
        }
    }
}
