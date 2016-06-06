//
//  gifbase.swift
//  JFNetworkTest
//
//  Created by John Fisher on 6/4/16.
//  Copyright © 2016 John Fisher. All rights reserved.
//

import Foundation
import Alamofire

let gifBaseHost = "http://gifbase.com"

func getTags(handler: Response<AnyObject, NSError> -> Void) -> Void {
  Alamofire.request(.GET, "\(gifBaseHost)/js/tags.json")
    .responseJSON(completionHandler: handler)
}

func getImagesFromTag(tag: String, page: Int, handler: Response<AnyObject, NSError> -> Void) -> Void {
  Alamofire.request(.GET, "\(gifBaseHost)/tag/\(tag)", parameters: ["p": page, "format": "JSON"])
    .responseJSON(completionHandler: handler)
}
