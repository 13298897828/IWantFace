//
//  AnalyseModel.swift
//  IWantFace
//
//  Created by 张天琦 on 16/3/24.
//  Copyright © 2016年 C2H4. All rights reserved.
//

import UIKit

class AnalyseModel: NSObject {
    
    var coarseness:String!
    var gender:String!
    var total_score:String!
    var skin_age:String!
    var Tzone_oil_shine:String!
    var skin_color:String!
    var cheek_oil_shine:String!
    var blackhead_severity:String! //黑头严重程度
    var blackhead_number:String!
    var chin_oil_shine:String!
    var skin_color_desc:String!
    var pore_severity:String!
    var error_code:String!
    var error_msg:String!
  
    
    
//    init(coarseness:String,gender:String,total_score:String,Tzone_oil_shine:String,skin_color:String,cheek_oil_shine:String,blackhead_severity:String,blackhead_number:String,chin_oil_shine:String,skin_color_desc:String,pore_severity:String,error_code:String,error_msg:String) {
//        self.coarseness = coarseness
//        self.gender = gender
//        self.total_score = total_score
//        self.Tzone_oil_shine = Tzone_oil_shine
//        self.skin_color = skin_color
//        self.cheek_oil_shine = cheek_oil_shine
//        self.blackhead_severity = blackhead_severity
//        self.blackhead_number = blackhead_number
//        self.chin_oil_shine = chin_oil_shine
//        self.skin_color_desc = skin_color_desc
//        self.pore_severity = pore_severity
//        self.error_code = error_code
//        self.error_msg = error_msg
//        
    

    
        
    
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        print("error-------------------------")
    }
    
    
    
//    coarseness : 鸡蛋壳
//    gender : male
//    total_score : 78
//    skin_age : 24
//    Tzone_oil_shine : 0.379763610343
//    skin_color : 2
//    cheek_oil_shine : 0.185335518205
//    blackhead_severity : 2
//    blackhead_number : 44
//    chin_oil_shine : 0.388264998369
//    skin_color_desc : 正常
//    pore_severity : 较粗大
//    error_code : 0
//    error_msg : OK

}
