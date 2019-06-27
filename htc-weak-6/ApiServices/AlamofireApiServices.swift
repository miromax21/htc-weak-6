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
    var error : String?
    var cacheInterval:Double = 7.0
    fileprivate var hasMore:Bool = false
    fileprivate let cache = URLCache.shared
    init(tag:String, pageCount: Int = 10) {
        self.tag = tag
        self.pageCount = pageCount
    }
    
    fileprivate let githubUrl = "https://api.stackexchange.com/2.2/questions?order=desc&sort=activity&site=stackoverflow&filter=!*0Orc(*JEOizSDbd.)b-4JciVz_ULBWOHfaWDAqfq"
    
    func getGuestionse(tag:String, completion: @escaping (_ responce:Questionanswer) -> ()) {
        self.tag = tag
        inProces = true
        
        let url = URL(string: self.githubUrl + "&tagged=\(self.tag)&page=\(self.pageNumber)&pagesize=\(self.pageCount)")!
        let ar = Alamofire.request(url)
        self.getDataFromCacheByTimer(alamofireRequest: ar, url: url) { (items, error) in
            completion(Questionanswer.success(items: items))
        }
        
        DispatchQueue.global(qos: .background).async{
            ar.responseJSON { response in
                self.error = nil
                var errors = [String]()
                if let responseError = response.error {
                    errors.append(responseError.localizedDescription)
                    self.getDataFromCacheByURl(url: url, completion: { (items, error) in
                        if let error = error{
                            errors.append(error)
                        }
                        completion(Questionanswer.error(items: items, errorMessage: errors))
                    })
                }else{
                    
                    let completeItems = self.getModelByResponse(response: response)
                    completion(Questionanswer.success(items: completeItems))
                }
                self.inProces = false
            }
        }
    }
    
    
    func getQuestions(tag:String, completion: @escaping ([ItemModel]?,String?) -> ()){
        self.tag = tag
        inProces = true
        
        let url = URL(string: self.githubUrl + "&tagged=\(self.tag)&page=\(self.pageNumber)&pagesize=\(self.pageCount)")!
        let ar = Alamofire.request(url)
        self.getDataFromCacheByTimer(alamofireRequest: ar, url: url) { (items, error) in
            completion(items,error)
        }
        
        DispatchQueue.global(qos: .background).async{
            ar.responseJSON { response in
                self.error = nil
                var completeItems : [ItemModel]?
                if let error = response.error {
                    self.error = error.localizedDescription
                    self.getDataFromCacheByURl(url: url, completion: { [unowned self] (items, error) in
                        completeItems = items
                        if let  error = error{
                            self.error = error
                        }
                    })
                }else{
                    completeItems = self.getModelByResponse(response: response)
                }
                completion(completeItems, self.error)
                self.inProces = false
            }
        }
    }
    
    func next(completion: @escaping ([ItemModel]?, String?) -> ()) {
        guard !inProces || !hasMore else { return }
        pageNumber += 1
        return getQuestions(tag: self.tag, completion: completion)
    }
    
    func getModelByResponse(response:DataResponse<Any>) -> [ItemModel]?{
        guard response.result.isSuccess,  let responceData = response.data else{return nil}
        let cachData = CachedURLResponse(response: response.response!, data: responceData)
        cache.storeCachedResponse(cachData, for: response.request!)
        if let value = response.value as? [String: AnyObject] {
            self.error = value["error_message"] as? String
        }
        return convertDataToModel(responceData: responceData)
    }
    
    func convertDataToModel(responceData:Data?) -> [ItemModel]? {
        guard let responceData = responceData else { self.error = "data loading error"; return nil}
        
        guard  let data = try? JSONDecoder().decode(ServerDataModel.self, from: responceData), let items = data.items else {return nil }
        self.hasMore = data.has_more
        return items
    }
    
    func getDataFromCacheByTimer(alamofireRequest:DataRequest, url:URL, completion: @escaping ([ItemModel]?,String?) -> ())  {
        Timer.scheduledTimer(withTimeInterval: self.cacheInterval, repeats: false) { timer in
            if !self.inProces {return}
            alamofireRequest.cancel()
            DispatchQueue.main.async {
                self.getDataFromCacheByURl(url: url, completion: { (items, error) in
                    completion(items,error)
                })
            }
            self.inProces = false
        }
    }
    
    func getDataFromCacheByURl(url:URL, completion: @escaping ([ItemModel]?,String?) -> ()) {
        let data = self.cache.cachedResponse(for: URLRequest(url: url))?.data
        completion(self.convertDataToModel(responceData: data), self.error)
    }
}
