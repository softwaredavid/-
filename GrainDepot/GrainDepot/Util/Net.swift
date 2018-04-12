//
//  Net.swift
//  GrainDepot
//
//  Created by shuaitong du on 2017/11/2.
//  Copyright © 2017年 EdisonDu. All rights reserved.
//

import UIKit
import AFNetworking

class Net: NSObject {
    static func get(url:String,par:[String:Any]?=nil,success:((Any?)->())?,error e:(() -> ())?) {
        let m = AFHTTPSessionManager()
        m.responseSerializer.acceptableContentTypes = ["application/hal+json"]
      //  m.responseSerializer = AFHTTPResponseSerializer()
        m.get(url, parameters: par, progress: nil, success: { (task, responseObject) in
            if success != nil {
                success!(responseObject)
            }
        }) { (task, error) in
            print(error)
        }
    }
    static func post(url:String,par:[String:Any]?=nil,success:((Any?)->())?,error e:(() -> ())?) {
        let m = AFHTTPSessionManager()
        m.requestSerializer = AFJSONRequestSerializer()
            m.post(url, parameters: par, progress: nil, success: { (task, responseObject) in
    
            }) { (task, error) in
            }
    }
}
