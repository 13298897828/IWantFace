//
//  FaceModel.swift
//  WantFace
//
//  Created by 张天琦 on 16/2/20.
//  Copyright © 2016年 YiXi. All rights reserved.
//

import UIKit


class FaceModel: NSObject {
 
    
    var face_profile:NSArray?
    var left_eye:NSArray!
    var right_eye:NSArray!
    var left_eyebrow:NSArray!
    var right_eyebrow:NSArray!
    var nose:NSArray!
    var mouth:NSArray!
 
    
    override init(){
        
    }
    
    init(face_profile:NSArray,left_eye:NSArray,right_eye:NSArray,left_eyeblow:NSArray,right_eyeblow:NSArray,nose:NSArray,mouth:NSArray) {
        self.face_profile = face_profile
        self.left_eyebrow = left_eyeblow
        self.left_eye = left_eye
        self.right_eyebrow = right_eyeblow
        self.right_eye = right_eye
        self.nose = nose
        self.mouth = mouth

    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        print("error-------------------------")
    }
    

}
