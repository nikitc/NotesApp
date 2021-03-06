//
//  PostNoteToVKOperation.swift
//  Notes
//
//  Created by Admin on 15.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import Foundation

class PostNoteToVKOperation : Operation {
    private let note: Note
    private let accessToken: String
    private let ownerId: String
    public var hasError: Bool
    
    init(accessToken: String, ownerId: String, note: Note) {
        self.accessToken = accessToken
        self.note = note
        self.ownerId = ownerId
        self.hasError = false
    }
    
    override func main() {
        let url = URL(string: "https://api.vk.com/method/wall.post?")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "owner_id=\(self.ownerId)&message=\(self.note.content)&access_token=\(self.accessToken)&v=5.74"
        request.httpBody = postString.data(using: .utf8)
        print("https://api.vk.com/method/wall.post?" + postString)
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error = \(String(describing: error))")
                self.hasError = true
                semaphore.signal()
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode = \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                self.hasError = true
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
}
