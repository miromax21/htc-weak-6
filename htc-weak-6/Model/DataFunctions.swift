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
    static func getQuestionsData(url:String, completion: @escaping () -> ()){
        DispatchQueue.global(qos: .userInteractive).async{
            Alamofire.request(url).responseJSON { response in
                DataModel.data = try? JSONDecoder().decode(ServerData.self, from: response.data!)
                completion()
            }
        }
    }
}
