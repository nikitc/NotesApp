//
//  SaveVKDataOperation.swift
//  Notes
//
//  Created by Admin on 19.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import Foundation

class SaveVKDataOperation : Operation, VKDataInfo {
    internal let vkData: VKData
    
    private let accessToken: String
    private let ownerId: String
    
    init(vkData: VKData, accessToken: String, ownerId: String) {
        self.vkData = vkData
        self.accessToken = accessToken
        self.ownerId = ownerId
    }
    
    override func main() {
        vkData.saveData(accessToken: self.accessToken, ownerId: self.ownerId)
    }
}
