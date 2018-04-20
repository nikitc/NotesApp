//
//  GetVKDataOperation.swift
//  Notes
//
//  Created by Admin on 19.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import Foundation

class GetVKDataOperation : Operation, VKDataInfo {
    internal let vkData: VKData
    
    public var accessToken: String?
    public var ownerId: String?
    
    init(vkData: VKData) {
        self.vkData = vkData
    }
    
    override func main() {
        self.accessToken = vkData.getAccessToken()
        self.ownerId = vkData.getOwnerId()
    }
}
