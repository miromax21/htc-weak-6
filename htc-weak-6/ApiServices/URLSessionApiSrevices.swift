//
//  URLSessionApiSrevice.swift
//  htc-weak-6
//
//  Created by maxim mironov on 14/05/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//


import Foundation
class URLSessionApiSrevices: GetQuestionsProtocol {

    var tag : String = ""
    var pageNumber : Int = 1
    var pageCount:Int
    var inProces : Bool = false
    var dataTask: URLSessionDataTask?
    fileprivate let githubUrl = "https://api.stackexchange.com/2.2/questions?order=desc&sort=activity&site=stackoverflow&filter=!0WJ3YL7KJOsP46r755kycqqs8"
    
    init(tag:String, pageCount: Int = 10) {
        self.tag = tag
        self.pageCount = pageCount
    }

    func getQuestions(tag:String, completion: @escaping ([ItemModel]) -> ()) {
        guard !inProces else { return }
        inProces = true
        let defaultSession = URLSession(configuration: .default)
        dataTask?.cancel()
        let url = URL(string: self.githubUrl + "&tagged=\(tag)&page=\(self.pageNumber)&pagesize=\(self.pageCount)")!
        self.dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer { self.dataTask = nil }
            DispatchQueue.main.async {
                self.inProces = false
                completion(self.convertDataToModel(data: data, resp: response, error: error))
            }
           
        }
         self.dataTask?.resume()
    }

    func next(completion: @escaping ([ItemModel]?) -> ()) {
        print("asd")
        DispatchQueue.main.async {
            completion([ItemModel]())
        }
    }
    func convertDataToModel(data:Data?,resp: URLResponse?,error: Error?) -> [ItemModel]{
        if let error = error {
            print(error)
            return [ItemModel]()
        }
        guard let data = data, let resp = resp as? HTTPURLResponse, resp.statusCode == 200  else { return [ItemModel]() }
        guard  let serverDataModel = try? JSONDecoder().decode(ServerDataModel.self, from: data),  let items = serverDataModel.items else {
            return [ItemModel]()
        }
        return items
    }

}
