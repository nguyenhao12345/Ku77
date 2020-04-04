//
//  Service.swift
//  MyApplication
//
//  Created by NguyenHao on 4/2/20.
//  Copyright © 2020 NguyenHao. All rights reserved.
//

import Foundation


enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    var result: String {
        return self.rawValue
    }
}

enum StatusRequest {
    case errorURL
    case errorNetwork
    case dataEmpty
    case success
}

class Service {
    static var share = Service()
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    // true ---> success
    func request(url: String ,method: HttpMethod?, completion:@escaping (StatusRequest,Any?)->()) {
        let text = url
        guard let url: URL = URL(string: text) else {
            completion(.errorURL, nil)
            return }
        var request:URLRequest = URLRequest(url: url)
        if method == HttpMethod.POST{
            request.httpMethod = method?.result
            let body:NSMutableData = NSMutableData()
            let boundary = generateBoundaryString()
            let Authorization = "Bearer "
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.setValue(Authorization, forHTTPHeaderField: "Authorization")
            request.httpBody = body as Data
        } else if method == HttpMethod.GET {
            let Authorization = "Bearer "
            request.setValue(Authorization, forHTTPHeaderField: "Authorization")
        }
        let session:URLSession = URLSession.shared
        if CheckInternet.Connection() {
            session.dataTask(with: request, completionHandler: {
                (data,res,err) in
                if data == nil || res == nil {
                    DispatchQueue.main.async {
                        completion(.dataEmpty, nil)
                    }
                    return
                }
                else {
                    let result = String(data: data!, encoding: .utf8)
                    DispatchQueue.main.async {
                        completion(.success, result)
                    }
                }
            }).resume()
        }
        else {
            DispatchQueue.main.async {
                completion(.errorNetwork, nil)
            }
            session.dataTask(with: request).cancel()
        }
    }
}

