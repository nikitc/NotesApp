//
//  AuthenticationVKOperation.swift
//  Notes
//
//  Created by Admin on 18.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import Foundation

class AuthentificationVKOperation : Operation {
    public var accessToken: String
    private let clientId = "4821803"
    private let display = "mobile"
    private let redirectUri = "http://oauth.vk.com/blank.html&display=mobile&response_type=token"
    private let version = "5.74"
    
    override init() {
        self.accessToken = ""
    }
    
    override func main() {
        let url = URL(string: "https://oauth.vk.com/authorize?")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let getString = "client_id=\(self.clientId)&display=\(self.display)&redirect_uri\(self.redirectUri)&v=\(version)"

        request.httpBody = getString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error = \(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode = \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
}
