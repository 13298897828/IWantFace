//
//  TQImageHelp.swift
//  IWantFace
//
//  Created by 张天琦 on 16/3/7.
//  Copyright © 2016年 C2H4. All rights reserved.
//

import UIKit

class TQImageHelp: UIImage {


    func fitSizeinSize(thisSize:CGSize,afterSize:CGSize) -> CGSize{
        var scale = CGFloat()
        var newSize = thisSize
        if newSize.height > 0 && (newSize.height > afterSize.height){
            scale = afterSize.height / newSize.height
            newSize.width *= scale
            newSize.height *= scale
        }
        if newSize.width > 0 && (newSize.width > afterSize.width){
            scale = afterSize.width / newSize.width
            newSize.width *= scale
            newSize.height *= scale
        }
        let height = newSize.height
        let h = height % 3
        newSize.height = height - h
        return newSize
    }
 
    func frameSize(thisSize:CGSize,inSize:CGSize) -> CGRect {
        let size = fitSizeinSize(thisSize, afterSize: inSize)
        let dWidth = inSize.width - size.width
        let dHeight = inSize.height - size.height
        return CGRectMake(dWidth / 2, dHeight / 2, size.width, size.height)
        
    }
//    + (UIImage *)image:(UIImage *)image fitInSize:(CGSize)viewsize
//    {
//    UIGraphicsBeginImageContext(viewsize);
//    [image drawInRect:[VSImageHelp frameSize:image.size inSize:viewsize]];
//    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newimg;
//    }

    func image(image:UIImage,fitInSize:CGSize) ->UIImage {
        UIGraphicsBeginImageContext(fitInSize)
        image.drawInRect(TQImageHelp().frameSize(image.size, inSize: fitInSize))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        return newImg
        
    }
}
