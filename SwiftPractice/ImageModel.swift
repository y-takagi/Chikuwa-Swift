//
//  ImageModel.swift
//  SwiftPractice
//
//  Created by Yukiya Takagi on 2014/10/19.
//  Copyright (c) 2014年 Yukiya Takagi. All rights reserved.
//

/* 
 * API DOC: http://dev.tiqav.com/
 *
 * Example Search Response
 * [
 *   {"id":"3om","ext":"jpg","height":1442,"width":1036,"source_url":"http://example.com/image1.jpg"},
 *   {"id":"1eb","ext":"jpg","height":171,"width":250,"source_url":"http://example.com/image2.jpg"}
 * ]
 */


import Foundation

let kOriginalFormat:String = "http://tiqav.com/%@.%@"
let kThumbnailFormat:String = "http://tiqav.com/%@.th.jpg"
let kThumbnailWidth:CGFloat = 142.0

class ImageModel {
    var imageId: String = String()
    var ext: String = String()
    var height: Int = Int()
    var width: Int = Int()
    var sourceUrl: String = String()
    typealias ImageListResponseBlock = (images: [ImageModel]) -> Void
    
    init(json: JSON) {
        self.imageId = json["id"].asString!
        self.ext = json["ext"].asString!
        self.height = json["height"].asInt!
        self.width = json["width"].asInt!
        self.sourceUrl = json["source_url"].asString!
    }
    
    class func parseResponse(completedOperation: MKNetworkOperation) -> [ImageModel] {
        let responseData = completedOperation.responseData()
        let result = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSArray
        var images = [ImageModel]()
        for imageDict in result {
            let m = ImageModel(json: JSON(imageDict))
            images.append(m)
        }
        return images
    }
    
    class func newest(completionBlock: ImageListResponseBlock, errorBlock: MKNKResponseErrorBlock) -> Void {
        ApiEngine.sharedInstance.run("GET",
            path: "search/newest.json",
            params: nil,
            completionBlock: { (completedOperation) -> Void in
                completionBlock(images: ImageModel.parseResponse(completedOperation))
            },
            errorBlock: { (completedOperation, error) -> Void in
                errorBlock(completedOperation, error)
            }
        )
    }
    
    class func search(query: String, completionBlock: ImageListResponseBlock, errorBlock: MKNKResponseErrorBlock) -> Void {
        var params = ["q": query]
        ApiEngine.sharedInstance.run("GET", path: "search.json",
            params: params,
            completionBlock: { (completedOperation) -> Void in
                completionBlock(images: ImageModel.parseResponse(completedOperation))
            },
            errorBlock: { (completedOperation, error) -> Void in
                errorBlock(completedOperation, error)
            }
        )
    }
    
    func originalUrl() -> NSURL {
        let s = String(format: kOriginalFormat, self.imageId, self.ext)
        return NSURL(string: s)
    }
    
    func thumbnailUrl() -> NSURL {
        let s = String(format: kThumbnailFormat, self.imageId)
        return NSURL(string: s)
    }
    
    func thumbnailSize() -> CGSize {
        let height = CGFloat(self.height) * kThumbnailWidth/CGFloat(self.width)
        return CGSizeMake(kThumbnailWidth, height)
    }
}
