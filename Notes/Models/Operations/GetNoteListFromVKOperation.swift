//
//  GetNoteListFromVKOperation.swift
//  Notes
//
//  Created by Admin on 15.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import Foundation

class GetNoteListFromVKOperation : Operation {
    public var notes: [Note] = []
    private let accessToken: String
    private let ownerId: String
    
    init(accessToken: String, ownerId: String) {
        self.accessToken = accessToken
        self.ownerId = ownerId
    }
    
    override func main() {
        let url = URL(string: "https://api.vk.com/method/wall.get?")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let getString = "owner_id=\(self.ownerId)&access_token=\(self.accessToken)&v=5.74"
        request.httpBody = getString.data(using: .utf8)
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error = \(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode = \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            guard let responseString = String(data: data, encoding: .utf8) else { return }
            self.parseResponse(responseData: responseString)
            print("responseString = \(String(describing: responseString))")
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func parseResponse(responseData: String) {
        do {
            let data = responseData.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            
            guard let response = json["response"] as? [String: AnyObject] else { return }
            guard let items = response["items"] as? [[String: AnyObject]] else { return }
            
            for item in items {
                guard let info = item["text"] as? String else { continue }
                let note = Note(title: "Note from VK", content: info)
                notes.append(note)
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
}
