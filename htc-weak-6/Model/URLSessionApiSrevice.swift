//
//  DataFunctions.swift
//  htc-weak-6
//
//  Created by maxim mironov on 30/04/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
protocol GetQuestionsProtocol{
    func getQuestionsAlamofire(tag: String, completion: @escaping ([ItemModel]) -> ())
    func getQuestionsSession(tag: String, completion: @escaping ([ItemModel]) -> ())
}
class URLSessionApiSrevice:GetQuestionsProtocol {
    func getQuestionsSession(tag: String, completion: @escaping ([ItemModel]) -> ()) {
        print("sd")
    }
    
    let githubUrl = "https://api.stackexchange.com/2.2/questions?order=desc&sort=activity&site=stackoverflow&filter=!0WJ3YL7KJOsP46r755kycqqs8"
//    static func getQuestionsData(url:String, completion: @escaping (Bool) -> ()){
//        DispatchQueue.global(qos: .userInteractive).async{
//            Alamofire.request(url).responseJSON { response in
//
//                guard response.result.isSuccess,  let responceData = response.data else{
//                    completion(false)
//                    return
//                }
//                DataModel.data = try? JSONDecoder().decode(ServerDataModel.self, from: responceData)
//                completion(true)
//            }
//        }
//    }

    func getQuestionsAlamofire(tag: String, completion: @escaping ([ItemModel]) -> ()){
        DispatchQueue.global(qos: .userInteractive).async{
            Alamofire.request(self.githubUrl + "&tagged=\(tag)").responseJSON { response in
                guard response.result.isSuccess,  let responceData = response.data else{
                    completion([ItemModel]())
                    return
                }
                let data = try? JSONDecoder().decode(ServerDataModel.self, from: responceData)
                if data == nil{
                    completion([ItemModel]())
                }else{
                    completion(data!.items)
                }
            }
        }
    }
}
