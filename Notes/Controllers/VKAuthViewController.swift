//
//  VkAuthViewController.swift
//  Notes
//
//  Created by Admin on 19.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import Foundation
import UIKit

class VKAuthViewController: UIViewController, UIWebViewDelegate {
    
    private let clientId = "4821803"
    private let display = "mobile"
    private let redirectUri = "http://oauth.vk.com/blank.html&display=mobile&response_type=token&scope=wall"
    private let version = "5.74"

    weak var operationsFactory: OperationFactory!
    
    @IBOutlet weak var AuthWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = getUrlAuth()
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        AuthWebView.delegate = self
        AuthWebView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let url = webView.request?.url?.absoluteString{
            if url.range(of: "access") == nil {
                return
            }
            let urlArr = url.components(separatedBy: "#")
            let query = urlArr[1]
            
            let params = query.components(separatedBy: "&")
            let accessTokenInfo = params[0].components(separatedBy: "=")
            let userIdInfo = params[2].components(separatedBy: "=")
            
            let op = operationsFactory.buildSaveVKDataOperation(accessToken: accessTokenInfo[1], ownerId: userIdInfo[1])
            let uop = BlockOperation {
                self.navigationController?.popViewController(animated: true)
            }
            
            uop.addDependency(op)
            OperationQueue.main.addOperations([op, uop], waitUntilFinished: false)
        }
    }
    
    func getUrlAuth() -> String {
        return "https://oauth.vk.com/authorize?client_id=\(self.clientId)&display=\(self.display)&redirect_uri=\(self.redirectUri)&v=\(version)"
    }
}
