//
//  URLSessionApiSrevice.swift
//  htc-weak-6
//
//  Created by maxim mironov on 14/05/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//


import Foundation
class URLSessionApiSrevices {//: GetQuestionsProtocol {
    var tag : String = ""
    var pageNumber : Int = 1
    var pageCount:Int
    var inProces : Bool = false
    var error : String?
    var cacheInterval:Double = 5.0
    fileprivate var currentRequest : URLRequest?
    fileprivate var hasMore:Bool = false
    fileprivate let cache = URLCache.shared
    fileprivate var dataTask: URLSessionDataTask?
    fileprivate let githubUrl = "https://api.stackexchange.com/2.2/questions?order=desc&sort=activity&site=stackoverflow&filter=!*0Orc(*JEOizSDbd.)b-4JciVz_ULBWOHfaWDAqfq"
    init(tag:String, pageCount: Int = 10) {
        self.tag = tag
        self.pageCount = pageCount
    }
    
    func getQuestions(tag:String, completion: @escaping ([ItemModel]?,String?) -> ()) {
        guard !inProces else { return }
        inProces = true
        let defaultSession = URLSession(configuration: .default)
        
        self.dataTask?.cancel()
        let url = URL(string: self.githubUrl + "&tagged=\(tag)&page=\(self.pageNumber)&pagesize=\(self.pageCount)")!
        self.dataTask = defaultSession.dataTask(with: url) { data, response, error in
            var completeItems : [ItemModel]?
            if let error = error{
                self.error = error.localizedDescription
                self.getDataFromCacheByURl(url: url, completion: { [unowned self] (items, error) in
                    completeItems = items
                    if let  error = error{
                        self.error = error
                    }
                })
            }else{
                completeItems = self.getModelByResponse(data: data, resp: response, error: error)
            }
            
            self.currentRequest = self.dataTask?.currentRequest
            self.inProces = false
            defer { self.dataTask = nil }
            DispatchQueue.main.async {
                completion(completeItems, self.error)
            }
            
        }
        self.dataTask?.resume()
        self.getDataFromCacheByTimer(url: url) { (items, error) in
            completion(items,error)
        }
    }
    
    func next(completion: @escaping ([ItemModel]?, String?) -> ()) {
        guard !inProces || !hasMore else { return completion(nil,"конец списка элементов")}
        pageNumber += 1
        return getQuestions(tag: self.tag, completion: completion)
    }
    
    func getModelByResponse(data:Data?,resp: URLResponse?,error: Error?) -> [ItemModel]?{
        if let error = error {
            self.error = error.localizedDescription
            return nil
        }
        guard let data = data, let resp = resp  else { return [ItemModel]() }
        
        let cachData = CachedURLResponse(response: resp, data: data)
        self.cache.storeCachedResponse(cachData, for: self.dataTask!.currentRequest!)
        
        cache.storeCachedResponse(cachData, for:self.currentRequest!)
        return convertDataToModel(responceData: data)
    }
    
    func convertDataToModel(responceData:Data?) -> [ItemModel]? {
        guard let responceData = responceData else { self.error = "data loading error"; return nil}
        guard  let data = try? JSONDecoder().decode(ServerDataModel.self, from: responceData), let items = data.items else {return nil }
        self.hasMore = data.has_more
        return items
    }
    
    func getDataFromCacheByTimer(url:URL, completion: @escaping ([ItemModel]?,String?) -> ())  {
        Timer.scheduledTimer(withTimeInterval: self.cacheInterval, repeats: false) { timer in
            if !self.inProces {return}
            self.dataTask?.cancel()
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
