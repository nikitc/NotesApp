//
//  VkData.swift
//  Notes
//
//  Created by Admin on 19.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import Foundation

class VKData {
    private var accessToken: String?
    private var ownerId: String?
    
    init() { }
    
    func saveData(accessToken: String, ownerId: String) {
        self.accessToken = accessToken
        self.ownerId = ownerId
    }
    
    func getAccessToken() -> String? {
        return accessToken
    }
    
    func getOwnerId() -> String? {
        return ownerId
    }
}
