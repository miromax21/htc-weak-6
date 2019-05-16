//
//  URLSessionApiSrevice.swift
//  htc-weak-6
//
//  Created by maxim mironov on 14/05/2019.
//  Copyright © 2019 maxim mironov. All rights reserved.
//


import Foundation
class URLSessionApiSrevices: GetQuestionsProtocol {
    
    fileprivate let githubUrl = "https://api.stackexchange.com/2.2/questions?order=desc&sort=activity&site=stackoverflow&filter=!0WJ3YL7KJOsP46r755kycqqs8"
    
    var dataTask: URLSessionDataTask?
    
    func getQuestions(tag: String, completion: @escaping ([ItemModel]) -> ()) {
        let defaultSession = URLSession(configuration: .default)
        dataTask?.cancel()
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: self.githubUrl + "&tagged=\(tag)")!
            self.dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                if let error = error {
                    DispatchQueue.main.async {
                        completion([ItemModel]())
                    }
                    print(error)
                    return
                }
                else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    let serverDataModel = try? JSONDecoder().decode(ServerDataModel.self, from: data)
                    guard serverDataModel != nil, let items = serverDataModel?.items else{
                        DispatchQueue.main.async {
                            completion([ItemModel]())
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        completion(items)
                    }
                }
            }
            self.dataTask?.resume()
        }
    }
    
}
