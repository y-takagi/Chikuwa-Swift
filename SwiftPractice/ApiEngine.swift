//
//  ApiEngine.swift
//  SwiftPractice
//
//  Created by Yukiya Takagi on 2014/10/19.
//  Copyright (c) 2014年 Yukiya Takagi. All rights reserved.
//

import Foundation

let kHostName:String = "api.tiqav.com"

class ApiEngine : MKNetworkEngine {
    class var sharedInstance : ApiEngine {
        struct Static {
            static let instance : ApiEngine = ApiEngine(hostName: kHostName)
        }
        return Static.instance
    }
    
    func run(method: String, path: String, params: [String: String]?, completionBlock: MKNKResponseBlock, errorBlock: MKNKResponseErrorBlock) -> MKNetworkOperation {
        let op = self.operationWithPath(path, params: params, httpMethod: method)
        op.addCompletionHandler({(completedOperation)-> Void in
            completionBlock(completedOperation)
            }, errorHandler: errorBlock)
        self.enqueueOperation(op)
        return op
    }
}
