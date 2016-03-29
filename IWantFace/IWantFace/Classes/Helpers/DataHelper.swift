//
//  DataHelper.swift
//  QiuBai_Demo
//
//  Created by LIZE on 15/10/5.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

import UIKit
import SwiftHTTP
import MJExtension
typealias Result = () -> Void

 

class DataHelper: NSObject {
    // 单例对象
    static let SharedDataHelper = DataHelper()
    
    let locationManager = CLLocationManager()
    let idfv = UIDevice.currentDevice().identifierForVendor!.UUIDString
    var analyseModel = AnalyseModel()
    var latitude: String? = nil
    var longitude: String? = nil
    var timeString: String? = nil
    private var url: NSURL?
    private var timer: NSTimer = NSTimer()
    private var startWaiting = false
    var exif = AnyObject!()
//
    var result: Result!         // 用于回调的闭包
    
    
    
    // MARK: - 声明方法
    // 请求网路数据
 
    func requestData(a:Int) {
 
    }
    func uploadImage(imageURL: NSURL!){
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            
            do {
                let opt = try HTTP.POST("http://119.254.211.15/west/upload_analysis/", parameters: ["unique_id": self.idfv,
                    "time_stamp": self.timeString!,
                    "longitude":self.longitude!,
                    "latitude": self.latitude!, "image": Upload(fileUrl: imageURL!)])
                opt.start { response in
                    if let error = response.error {
                        print("got an error: \(error)")
                        return
                    }
                    
                    self.analyseModel = AnalyseModel.mj_objectWithKeyValues(response.data)
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.result()
                        
                    })
                    
                }
            } catch let error {
                print("got an error creating the request: \(error)")
            }
            
        }
        
        
 
  
    }
}
