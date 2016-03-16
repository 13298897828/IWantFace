//
//  DBManager.swift
//  WantFace
//
//  Created by 张天琦 on 16/3/4.
//  Copyright © 2016年 YiXi. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import MJExtension
import Alamofire
//import LKNetwork


class DBManager: NSObject,CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let idfv = UIDevice.currentDevice().identifierForVendor!.UUIDString
    var latitude: String? = nil
    var longitude: String? = nil
    var timeString: String? = nil
    var url: NSURL?
    var timer: NSTimer = NSTimer()
    var receiveImage: UIImage = UIImage(named: "126")!
    var startWaiting = false
 

func uploadImage(imageURL: NSURL?){
    let params: Dictionary<String,AnyObject> = ["unique_id": idfv,
        "time_stamp": timeString!,
        "longitude":longitude!,
        "latitude": latitude!,
        "image":UIImage(data: NSData(contentsOfURL: imageURL!)!)!]
    let uploadURL = "http://119.254.211.15/west/temp_analysis/"
    LKNetworkTool.POST(uploadURL,
        params: params){
            print("result = \($0.result.value)")
            
            let result = $0.result.value as? [String: AnyObject]
            
//            self.model = BuyRecordModel(dict: result)
    }
 
    
//    let task = HTTPTask()

////    let uploadURL = "http://192.168.0.105:8000/west/temp_analysis/"
//    task.upload(uploadURL, method: .POST,
//        parameters: params,
//        progress: { (value: Double) in
//            print("progress: \(value)")
//            dispatch_async(dispatch_get_global_queue(0, 0), {
////                self.progress = value*0.2
//                if (value >= 0.99 && !self.startWaiting) {
//                    self.startWaiting = true
//                    self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
//                    print("upload complete")
//                }
//            })
//        }, completionHandler: {(response: HTTPResponse) in
//            if let err = response.error {
//                print("error: \(err.localizedDescription)")
//                return //also notify app of failure as needed
//            }
//            if let data = response.responseObject as? NSData {
//                let jsonDict = (try! NSJSONSerialization.JSONObjectWithData(data, options: [])) as! Dictionary<String, AnyObject>
//                print("receive json \(jsonDict)")
//                dispatch_async(dispatch_get_main_queue(), {
////                    self.parseHttpResult(jsonDict)
//                })
//            }
//    })
}
}
