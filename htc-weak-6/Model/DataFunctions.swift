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
class DataModelFunctions {
    static func getQuestionsData(url:String, completion: @escaping (Bool) -> ()){
        DispatchQueue.global(qos: .userInteractive).async{
            Alamofire.request(url).responseJSON { response in
                
                guard response.result.isSuccess,  let responceData = response.data else{
                    completion(false)
                    return
                }
                DataModel.data = try? JSONDecoder().decode(ServerDataModel.self, from: responceData)
                completion(true)
            }
        }
    }
    
    static func getAnswerData(url:String, completion: @escaping (Any) -> ()){
        DispatchQueue.global(qos: .userInteractive).async{
            Alamofire.request(url).responseJSON { response in
                
                guard response.result.isSuccess,  let responceData = response.data else{
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }

}
