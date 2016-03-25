
//
//  ScanViewController.swift
//  WantFace
//
//  Created by 张天琦 on 16/2/20.
//  Copyright © 2016年 YiXi. All rights reserved.
//

import UIKit
import AFImageHelper

class ScanViewController: UIViewController,CLLocationManagerDelegate{

//    地点
    let locationManager = CLLocationManager()
    var latitude: String?
    var longitude: String?
    var timestring:String?
    
//  数据模型
    let faceModel = FaceModel()
    let pointView:UIView = UIView()
    var faceProfilePoints = [CGPoint]()
    var leftEyePoints =  [CGPoint]()
    var leftEyeBlowPoints = [CGPoint]()
    var rightEyePoints = [CGPoint]()
    var rightEyeBlowPoints = [CGPoint]()
    var nosePoints = [CGPoint]()
    var mouthPoints = [CGPoint]()
    
    let cornerImage:UIImageView = UIImageView()
    var corverImage: UIView!
    var showImageUrl = NSURL!()
    var changeText:UITextField = UITextField()
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var scanImage: UIImageView!
    @IBOutlet weak var progressImgView: UIImageView!
    @IBOutlet weak var analysisLabel: UILabel!
    @IBOutlet weak var percentLabel: UICountingLabel!
    var corverViewLeft = UIView()
    var corverViewRight = UIView()
 
    @IBOutlet weak var backViewForPoint: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        var linePointAL = [CGPoint]()
        let layerAL = CAShapeLayer()
        var linePointAR = [CGPoint]()
        let layerAR = CAShapeLayer()
        var linePointBL = [CGPoint]()
        let layerBL = CAShapeLayer()
        var linePointBR = [CGPoint]()
        let layerBR = CAShapeLayer()
        var linePointCL = [CGPoint]()
        let layerCL = CAShapeLayer()
        var linePointCR = [CGPoint]()
        let layerCR = CAShapeLayer()
        var linePointDL = [CGPoint]()
        let layerDL = CAShapeLayer()
        var linePointDR = [CGPoint]()
        let layerDR = CAShapeLayer()
        var linePointEL = [CGPoint]()
        let layerEL = CAShapeLayer()
        var linePointER = [CGPoint]()
        let layerER = CAShapeLayer()
        var linePointFL = [CGPoint]()
        let layerFL = CAShapeLayer()
        var linePointFR = [CGPoint]()
        let layerFR = CAShapeLayer()
        var linePointGL = [CGPoint]()
        let layerGL = CAShapeLayer()
        var linePointGR = [CGPoint]()
        let layerGR = CAShapeLayer()
        var linePointHL = [CGPoint]()
        let layerHL = CAShapeLayer()
        var linePointHR = [CGPoint]()
        let layerHR = CAShapeLayer()
        var linePointIL = [CGPoint]()
        let layerIL = CAShapeLayer()
        var linePointIR = [CGPoint]()
        let layerIR = CAShapeLayer()
        var linePointJL = [CGPoint]()
        let layerJL = CAShapeLayer()
        var linePointJR = [CGPoint]()
        let layerJR = CAShapeLayer()
        var linePointKL = [CGPoint]()
        let layerKL = CAShapeLayer()
        var linePointKR = [CGPoint]()
        let layerKR = CAShapeLayer()
        var linePointLL = [CGPoint]()
        let layerLL = CAShapeLayer()
        var linePointLR = [CGPoint]()
        let layerLR = CAShapeLayer()
        var linePointML = [CGPoint]()
        let layerML = CAShapeLayer()
        var linePointMR = [CGPoint]()
        let layerMR = CAShapeLayer()
        var linePointNL = [CGPoint]()
        let layerNL = CAShapeLayer()
        var linePointNR = [CGPoint]()
        let layerNR = CAShapeLayer()
        var linePointOL = [CGPoint]()
        let layerOL = CAShapeLayer()
        var linePointOR = [CGPoint]()
        let layerOR = CAShapeLayer()
        var linePointPL = [CGPoint]()
        let layerPL = CAShapeLayer()
        var linePointPR = [CGPoint]()
        let layerPR = CAShapeLayer()
        var linePointQL = [CGPoint]()
        let layerQL = CAShapeLayer()
        var linePointQR = [CGPoint]()
        let layerQR = CAShapeLayer()
        var linePointRL = [CGPoint]()
        let layerRL = CAShapeLayer()
        var linePointRR = [CGPoint]()
        let layerRR = CAShapeLayer()
        
        
        
//       跳转页面
        DataHelper.SharedDataHelper.result = {
//        let stateVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StateViewController") as! StateViewController
            let contentVC = ContainViewController()
            self.presentViewController(contentVC, animated: true, completion: {
                 
            })
            
        }
        
//        时间地点
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        timestring = formatter.stringFromDate(date)
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        

        let auth = Auth.appSign(1000000, userId: nil)
        let sdk:TXQcloudFrSDK = TXQcloudFrSDK.init(name: Conf.instance().appId, authorization: auth)
        //     图片上的各种图
        
        
        self.view.backgroundColor = UIColor.blackColor()
        cornerImage.frame = CGRectMake(20, 20, imgView.bounds.size.width - 40, imgView.bounds.size.width - 40)
        cornerImage.image = UIImage(named: "focus")
        cornerImage.sizeToFit()
        self.imgView.addSubview(cornerImage)
        //        扫描图片
        scanImage.image = UIImage(named: "scan")
        self.scanImage.alpha = 0
        
        //      覆盖动画,百分比效果
        corverImage = UIView(frame: self.progressImgView.bounds)
        self.progressImgView.bringSubviewToFront(corverImage)
        corverImage.backgroundColor = UIColor.blackColor()
        corverImage.alpha = 0.5
        self.progressImgView.addSubview(corverImage)
        UIView.transitionWithView(corverImage, duration: 5, options: UIViewAnimationOptions.ShowHideTransitionViews, animations: { () -> Void in
            self.corverImage.frame = CGRectMake(self.corverImage.bounds.origin.x + self.corverImage.bounds.size.width - 0.1 , self.corverImage.bounds.origin.y , 0.1, self.corverImage.bounds.height)
            
            }) { (Bool) -> Void in
                
        }
        // MARK: - 添加观察者
        changeText.text = "aq"
        self.changeText.addObserver(self, forKeyPath: "text", options: NSKeyValueObservingOptions.New, context: nil)
        NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: #selector(ScanViewController.funcChangedtoA), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(1.6, target: self, selector: #selector(ScanViewController.funcChangedtoB), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(2.4, target: self, selector: #selector(ScanViewController.funcChangedtoC), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(3.2, target: self, selector: #selector(ScanViewController.funcChangedtoD), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: #selector(ScanViewController.funcChangedtoE), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(ScanViewController.funcChangedtoF), userInfo: nil, repeats: false)
        
        
        
        
        //        百分比数字显示
        percentLabel.countFrom(percentLabel.currentValue(), endValue: 100, duration: 5)
        let imageForShow = UIImage(data:NSData(contentsOfURL: showImageUrl)!)
        let image  = imageForShow?.resize(CGSize(width: (imageForShow?.size.width)! / 5, height: (imageForShow?.size.height)! / 5))
        
        
        
        self.imgView.image = imageForShow?.cutImage(imageForShow!, rect: CGRectMake(0, (imageForShow?.size.height)! / 16 * 3, (imageForShow?.size.width)!, (imageForShow?.size.height)! / 8 * 6))
        //            imageForShow?.imageRotatedByDegrees(90, flip: false)
        
        self.imgView.contentMode = UIViewContentMode.ScaleAspectFit
        //        imgView.clipsToBounds = true
        
        
        
        sdk.API_END_POINT = "http://api.youtu.qq.com/youtu"
        sdk.faceShape(image, successBlock: { (let responseObject) -> Void in
            
            //            解析数据
            let data = responseObject as! NSDictionary
            if data["errorcode"] as! Int != 0 {
                
                return
                
            }
            //            接收模型
            self.faceModel.setValuesForKeysWithDictionary((data["face_shape"] as! NSArray) [0] as! [String : AnyObject])
            //             解析点
            self.getPoints(data)
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                }, completion: { (Bool) -> Void in
                    
            })
            
            // MARK: - 眉毛点
            for i in 0...7 {
                
                self.leftEyeBlowPoints[i].y -= self.backViewForPoint.frame.size.height / 16 * 3
                self.rightEyeBlowPoints[i].y -= self.backViewForPoint.frame.size.height / 16 * 3
                self.imgPoints("layerLeftBlowPoint\(i)", point: CGPointMake(self.leftEyeBlowPoints[i].x ,self.leftEyeBlowPoints[i].y))
                self.imgPoints("layerRightBlowPoint\(i)", point: self.rightEyeBlowPoints[i])
                
            }
            
            // MARK: - 眼睛点
            
            for i in 0...4 {
                self.leftEyePoints[i].y -= self.backViewForPoint.frame.size.height / 16 * 3
                self.rightEyePoints[i].y -= self.backViewForPoint.frame.size.height / 16 * 3
                self.imgPoints("layerLeftEyePoint\(i)", point:self.leftEyePoints[i])
                self.imgPoints("layerRightEyePoint\(i)", point: self.rightEyePoints[i])
            }
            
            //    MARK: - 鼻子点
            
            for i in 0...12 {
                self.nosePoints[i].y -= self.backViewForPoint.frame.size.height / 16 * 3
                self.imgPoints("nosePoint\(i)", point: self.nosePoints[i])
                
            }
            //           // MARK: -  👄
            
            for i in 0...16 {
                
                self.mouthPoints[i].y -= self.backViewForPoint.frame.size.height / 16 * 3
                self.imgPoints("mouthPoint\(i)", point: self.mouthPoints[i])
            }
            
            //             // MARK: -  轮廓
            for i in 0...20  {
                
                self.faceProfilePoints[i].y -= self.backViewForPoint.frame.size.height / 16 * 3
                self.imgPoints("face\(i)", point:  CGPointMake(self.faceProfilePoints[i].x, self.faceProfilePoints[i].y))
                //
            }
            
            
            
            //           MARK: - 左一
            
            // MARK: -  最上
            linePointAL.append(self.nosePoints[2])
            linePointAL.append(self.leftEyePoints[4])
            linePointAL.append(self.leftEyeBlowPoints[3])
            linePointAL.append(self.leftEyeBlowPoints[4])
            linePointAL.append(self.leftEyeBlowPoints[5])
            linePointAL.append(self.leftEyeBlowPoints[6])
            linePointAL.append(self.leftEyeBlowPoints[7])
            linePointAL.append(self.leftEyeBlowPoints[0])
            linePointAL.append(self.faceProfilePoints[0])
            self.drawLine(layerAL, startPoint: self.nosePoints[2],linePoints:linePointAL)
            linePointAR.append(self.nosePoints[12])
            linePointAR.append(self.rightEyePoints[4])
            linePointAR.append(self.rightEyeBlowPoints[3])
            linePointAR.append(self.rightEyeBlowPoints[4])
            linePointAR.append(self.rightEyeBlowPoints[5])
            linePointAR.append(self.rightEyeBlowPoints[6])
            linePointAR.append(self.rightEyeBlowPoints[7])
            linePointAR.append(self.rightEyeBlowPoints[0])
            linePointAR.append(self.faceProfilePoints[20])
            self.drawLine(layerAR, startPoint: self.nosePoints[12], linePoints: linePointAR)
            
            //             // MARK: -  第二
            linePointBL.append(self.nosePoints[2])
            linePointBL.append(self.leftEyePoints[4])
            linePointBL.append(self.leftEyeBlowPoints[3])
            linePointBL.append(self.leftEyeBlowPoints[2])
            linePointBL.append(self.leftEyeBlowPoints[1])
            linePointBL.append(self.leftEyeBlowPoints[0])
            self.drawLine(layerBL, startPoint: self.nosePoints[2], linePoints: linePointBL)
            linePointBR.append(self.nosePoints[12])
            linePointBR.append(self.rightEyePoints[4])
            linePointBR.append(self.rightEyeBlowPoints[3])
            linePointBR.append(self.rightEyeBlowPoints[2])
            linePointBR.append(self.rightEyeBlowPoints[1])
            linePointBR.append(self.rightEyeBlowPoints[0])
            self.drawLine(layerBR, startPoint: self.nosePoints[12], linePoints: linePointBR)
            //             // MARK: - 中线
            linePointDL.append(self.nosePoints[2])
            linePointDL.append(self.leftEyeBlowPoints[4])
            linePointDL.append(CGPointMake((self.leftEyeBlowPoints[4].x + self.rightEyeBlowPoints[4].x) / 2, (self.leftEyeBlowPoints[4].y + self.rightEyeBlowPoints[4].y) / 2))
            self.drawLine(layerDL, startPoint: self.nosePoints[12], linePoints: linePointDL)
            
            linePointDR.append(self.nosePoints[12])
            linePointDR.append(self.rightEyeBlowPoints[4])
            linePointDR.append(CGPointMake((self.leftEyeBlowPoints[4].x + self.rightEyeBlowPoints[4].x) / 2, (self.leftEyeBlowPoints[4].y + self.rightEyeBlowPoints[4].y) / 2))
            self.drawLine(layerDR, startPoint: self.nosePoints[12], linePoints: linePointDR)
            
            //         // MARK: - 第三条
            linePointCL.append(self.nosePoints[2])
            linePointCL.append(self.leftEyePoints[4])
            linePointCL.append(self.leftEyePoints[3])
            linePointCL.append(self.leftEyePoints[2])
            linePointCL.append(self.leftEyePoints[1])
            linePointCL.append(self.leftEyePoints[0])
            linePointCL.append(self.leftEyeBlowPoints[0])
            linePointCL.append(self.faceProfilePoints[0])
            
            for i in 2...10 {
                
                linePointCL.append(self.faceProfilePoints[i])
                
            }
            self.drawLine(layerCL, startPoint: self.nosePoints[2],linePoints:linePointCL)
            
            linePointCR.append(self.nosePoints[12])
            linePointCR.append(self.rightEyePoints[4])
            linePointCR.append(self.rightEyePoints[3])
            linePointCR.append(self.rightEyePoints[2])
            linePointCR.append(self.rightEyePoints[1])
            linePointCR.append(self.rightEyePoints[0])
            linePointCR.append(self.rightEyeBlowPoints[0])
            linePointCR.append(self.faceProfilePoints[20])
            for var i = 18 ; i>9 ;i-- {
                
                linePointCR.append(self.faceProfilePoints[i])
                
            }
            self.drawLine(layerCR, startPoint: self.nosePoints[2],linePoints:linePointCR)
            
            //  MARK: - 第四条-1
            linePointEL.append(self.nosePoints[2])
            linePointEL.append(self.leftEyePoints[4])
            for var i = 4 ; i>=0 ;i-- {
                linePointEL.append(self.leftEyePoints[i])
            }
            linePointEL.append(CGPointMake((self.leftEyePoints[0].x + self.faceProfilePoints[2].x) / 2, self.faceProfilePoints[1].y))
            linePointEL.append(self.faceProfilePoints[0])
            self.drawLine(layerEL, startPoint: self.nosePoints[2],linePoints:linePointEL)
            
            linePointER.append(self.nosePoints[12])
            linePointER.append(self.rightEyePoints[4])
            for var i = 4 ; i>=0 ;i-- {
                linePointER.append(self.rightEyePoints[i])
            }
            linePointER.append(CGPointMake((self.rightEyePoints[0].x + self.faceProfilePoints[18].x) / 2, self.faceProfilePoints[19].y))
            linePointER.append(self.faceProfilePoints[20])
            self.drawLine(layerER, startPoint: self.nosePoints[12],linePoints:linePointER)
            
            //             // MARK: - 第四条-2
            linePointFL.append(self.nosePoints[2])
            for var i = 4 ; i>=0 ;i-- {
                linePointFL.append(self.leftEyePoints[4])
                linePointFL.append(self.leftEyePoints[i])
            }
            linePointFL.append(CGPointMake((self.leftEyePoints[0].x + self.faceProfilePoints[2].x) / 2, self.faceProfilePoints[1].y))
            linePointFL.append(self.faceProfilePoints[1])
            self.drawLine(layerFL, startPoint: self.nosePoints[2],linePoints:linePointFL)
            
            linePointFR.append(self.nosePoints[12])
            linePointFR.append(self.rightEyePoints[4])
            for var i = 4 ; i>=0 ;i-- {
                linePointFR.append(self.rightEyePoints[i])
            }
            linePointFR.append(CGPointMake((self.rightEyePoints[0].x + self.faceProfilePoints[18].x) / 2, self.faceProfilePoints[19].y))
            linePointFR.append(self.faceProfilePoints[19])
            self.drawLine(layerFR, startPoint: self.nosePoints[12],linePoints:linePointFR)
            
            //             // MARK: - 第四条-3
            linePointGL.append(self.nosePoints[2])
            linePointGL.append(self.leftEyePoints[4])
            for var i = 4 ; i>=0 ;i-- {
                linePointGL.append(self.leftEyePoints[i])
            }
            linePointGL.append(CGPointMake((self.leftEyePoints[0].x + self.faceProfilePoints[2].x) / 2, self.faceProfilePoints[1].y))
            linePointGL.append(self.faceProfilePoints[2])
            self.drawLine(layerGL, startPoint: self.nosePoints[2],linePoints:linePointGL)
            
            linePointGR.append(self.nosePoints[12])
            linePointGR.append(self.rightEyePoints[4])
            for var i = 4 ; i>=0 ;i-- {
                linePointGR.append(self.rightEyePoints[i])
            }
            linePointGR.append(CGPointMake((self.rightEyePoints[0].x + self.faceProfilePoints[18].x) / 2, self.faceProfilePoints[19].y))
            linePointGR.append(self.faceProfilePoints[18])
            self.drawLine(layerGR, startPoint: self.nosePoints[12],linePoints:linePointGR)
            //             // MARK: - 鼻子 -2
            
            linePointHL.append(self.nosePoints[2])
            linePointHL.append(self.nosePoints[3])
            linePointHL.append(self.nosePoints[4])
            linePointHL.append(self.nosePoints[5])
            linePointHL.append(self.mouthPoints[0])
            linePointHL.append(CGPointMake((self.mouthPoints[0].x + self.faceProfilePoints[4].x) / 2,(self.mouthPoints[0].y + self.faceProfilePoints[4].y) / 2))
            linePointHL.append(self.faceProfilePoints[2])
            self.drawLine(layerHL, startPoint: self.nosePoints[2],linePoints:linePointHL)
            
            linePointHR.append(self.nosePoints[12])
            linePointHR.append(self.nosePoints[11])
            linePointHR.append(self.nosePoints[10])
            linePointHR.append(self.nosePoints[9])
            linePointHR.append(self.mouthPoints[6])
            linePointHR.append(CGPointMake((self.mouthPoints[6].x + self.faceProfilePoints[16].x) / 2,(self.mouthPoints[6].y + self.faceProfilePoints[16].y) / 2))
            linePointHR.append(self.faceProfilePoints[18])
            self.drawLine(layerHR, startPoint: self.nosePoints[12],linePoints:linePointHR)
            
            //             // MARK: - 鼻子 -1
            linePointIL.append(self.nosePoints[2])
            linePointIL.append(self.nosePoints[3])
            linePointIL.append(self.nosePoints[4])
            linePointIL.append(self.nosePoints[5])
            linePointIL.append(CGPointMake((self.mouthPoints[0].x + self.faceProfilePoints[4].x) / 2,(self.mouthPoints[0].y + self.faceProfilePoints[4].y) / 2))
            linePointIL.append(self.faceProfilePoints[4])
            self.drawLine(layerIL, startPoint: self.nosePoints[2],linePoints:linePointIL)
            
            linePointIR.append(self.nosePoints[12])
            linePointIR.append(self.nosePoints[11])
            linePointIR.append(self.nosePoints[10])
            linePointIR.append(self.nosePoints[9])
            linePointIR.append(CGPointMake((self.mouthPoints[6].x + self.faceProfilePoints[16].x) / 2,(self.mouthPoints[6].y + self.faceProfilePoints[16].y) / 2))
            linePointIR.append(self.faceProfilePoints[16])
            self.drawLine(layerIR, startPoint: self.nosePoints[2],linePoints:linePointIR)
            
            //             // MARK: - 鼻子 - 3
            
            linePointJL.append(self.nosePoints[2])
            linePointJL.append(self.nosePoints[3])
            linePointJL.append(self.nosePoints[4])
            linePointJL.append(self.nosePoints[5])
            linePointJL.append(CGPointMake((self.mouthPoints[0].x + self.faceProfilePoints[4].x) / 2,(self.mouthPoints[0].y + self.faceProfilePoints[4].y) / 2))
            linePointJL.append(CGPointMake((self.leftEyePoints[0].x + self.faceProfilePoints[2].x) / 2, self.faceProfilePoints[1].y))
            self.drawLine(layerJL, startPoint: self.nosePoints[2],linePoints:linePointJL)
            
            linePointJR.append(self.nosePoints[12])
            linePointJR.append(self.nosePoints[11])
            linePointJR.append(self.nosePoints[10])
            linePointJR.append(self.nosePoints[9])
            linePointJR.append(CGPointMake((self.mouthPoints[6].x + self.faceProfilePoints[16].x) / 2,(self.mouthPoints[6].y + self.faceProfilePoints[16].y) / 2))
            linePointJR.append(CGPointMake((self.rightEyePoints[0].x + self.faceProfilePoints[18].x) / 2, self.faceProfilePoints[19].y))
            self.drawLine(layerJR, startPoint: self.nosePoints[12],linePoints:linePointJR)
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
            })
            // MARK: - 鼻子向下 - 左1
            for i in 2...6 {
                
                linePointKL.append(self.nosePoints[i])
                
            }
            
            
            linePointKL.append(self.mouthPoints[10])
            linePointKL.append(self.mouthPoints[11])
            linePointKL.append(self.mouthPoints[0])
            linePointKL.append(CGPointMake((self.mouthPoints[0].x + self.faceProfilePoints[4].x) / 2,(self.mouthPoints[0].y + self.faceProfilePoints[4].y) / 2))
            linePointKL.append(self.faceProfilePoints[6])
            self.drawLine(layerKL, startPoint: self.nosePoints[2],linePoints:linePointKL)
            
            
            for var i = 12; i > 7; i-- {
                
                linePointKR.append(self.nosePoints[i])
                
            }
            linePointKR.append(self.mouthPoints[8])
            linePointKR.append(self.mouthPoints[7])
            linePointKR.append(self.mouthPoints[6])
            linePointKR.append(CGPointMake((self.mouthPoints[6].x + self.faceProfilePoints[16].x) / 2,(self.mouthPoints[6].y + self.faceProfilePoints[16].y) / 2))
            linePointKR.append(self.faceProfilePoints[14])
            self.drawLine(layerKR, startPoint: self.nosePoints[12],linePoints:linePointKR)
            
            // MARK: - 鼻子向下 - 左2
            for i in 2...6 {
                
                linePointLL.append(self.nosePoints[i])
                
            }
            linePointLL.append(self.mouthPoints[10])
            linePointLL.append(self.mouthPoints[11])
            for i in 0...3 {
                linePointLL.append(self.mouthPoints[i])
            }
            self.drawLine(layerLL, startPoint: self.nosePoints[2],linePoints:linePointLL)
            
            for var i = 12; i > 7; i-- {
                linePointLR.append(self.nosePoints[i])
            }
            for var i = 8; i > 2; i-- {
                linePointLR.append(self.mouthPoints[i])
            }
            self.drawLine(layerLR, startPoint: self.nosePoints[2],linePoints:linePointLR)
            // MARK: - 连全鼻子
            for i in 2...7 {
                linePointML.append(self.nosePoints[i])
            }
            self.drawLine(layerML, startPoint: self.nosePoints[2],linePoints:linePointML)
            for var i = 12;i > 6; i--  {
                linePointMR.append(self.nosePoints[i])
            }
            self.drawLine(layerMR, startPoint: self.nosePoints[2],linePoints:linePointMR)
            // MARK: - 嘴上最上一条
            for i in 2...6 {
                linePointNL.append(self.nosePoints[i])
            }
            linePointNL.append(self.mouthPoints[10])
            linePointNL.append(self.mouthPoints[9])
            self.drawLine(layerNL, startPoint: self.nosePoints[2],linePoints:linePointNL)
            for var i = 12;i > 7; i--  {
                linePointNR.append(self.nosePoints[i])
            }
            linePointNR.append(self.mouthPoints[8])
            linePointNR.append(self.mouthPoints[9])
            self.drawLine(layerNR, startPoint: self.nosePoints[2],linePoints:linePointNR)
            // MARK: - 嘴上中间一条
            for i in 2...6 {
                linePointOL.append(self.nosePoints[i])
            }
            linePointOL.append(self.mouthPoints[10])
            linePointOL.append(self.mouthPoints[11])
            linePointOL.append(self.mouthPoints[0])
            linePointOL.append(self.mouthPoints[12])
            linePointOL.append(self.mouthPoints[13])
            linePointOL.append(self.mouthPoints[14])
            self.drawLine(layerOL, startPoint: self.nosePoints[2],linePoints:linePointOL)
            for var i = 12;i > 7;i--  {
                linePointOR.append(self.nosePoints[i])
            }
            linePointOR.append(self.mouthPoints[8])
            linePointOR.append(self.mouthPoints[7])
            linePointOR.append(self.mouthPoints[6])
            linePointOR.append(self.mouthPoints[16])
            linePointOR.append(self.mouthPoints[15])
            linePointOR.append(self.mouthPoints[14])
            self.drawLine(layerOR, startPoint: self.nosePoints[12],linePoints:linePointOR)
            
            
            for i in 2...6 {
                linePointPL.append(self.nosePoints[i])
            }
            linePointPL.append(self.mouthPoints[10])
            linePointPL.append(self.mouthPoints[11])
            linePointPL.append(self.mouthPoints[0])
            linePointPL.append(self.mouthPoints[1])
            linePointPL.append(self.mouthPoints[2])
            linePointPL.append(CGPointMake((self.faceProfilePoints[9].x + self.mouthPoints[1].x) / 2, (self.faceProfilePoints[9].y + self.mouthPoints[2].y) / 2))
            linePointPL.append(self.faceProfilePoints[8])
            self.drawLine(layerPL, startPoint: self.nosePoints[2],linePoints:linePointPL)
            
            
            for var i = 12; i > 7;i--  {
                linePointPR.append(self.nosePoints[i])
            }
            for var i = 8; i > 3; i-- {
                linePointPR.append(self.mouthPoints[i])
            }
            linePointPR.append(CGPointMake((self.faceProfilePoints[11].x + self.mouthPoints[5].x) / 2, (self.faceProfilePoints[11].y + self.mouthPoints[4].y) / 2))
            linePointPR.append(self.faceProfilePoints[12])
            self.drawLine(layerPR, startPoint: self.nosePoints[12],linePoints:linePointPR)
            
            //             // MARK: - 嘴下竖 2
            for i in 2...6 {
                linePointQL.append(self.nosePoints[i])
            }
            linePointQL.append(self.mouthPoints[10])
            linePointQL.append(self.mouthPoints[11])
            linePointQL.append(self.mouthPoints[0])
            linePointQL.append(self.mouthPoints[1])
            linePointQL.append(self.mouthPoints[2])
            linePointQL.append(CGPointMake((self.faceProfilePoints[9].x + self.mouthPoints[1].x) / 2, (self.faceProfilePoints[9].y + self.mouthPoints[2].y) / 2))
            linePointPL.append(self.faceProfilePoints[8])
            linePointQL.append(self.faceProfilePoints[9])
            self.drawLine(layerQL, startPoint: self.nosePoints[2],linePoints:linePointQL)
            
            for var i = 12; i > 7;i -= 1  {
                linePointQR.append(self.nosePoints[i])
            }
            for var i = 8; i > 3; i -= 1 {
                linePointQR.append(self.mouthPoints[i])
            }
            linePointQR.append(CGPointMake((self.faceProfilePoints[11].x + self.mouthPoints[5].x) / 2, (self.faceProfilePoints[11].y + self.mouthPoints[4].y) / 2))
            linePointQR.append(self.faceProfilePoints[11])
            self.drawLine(layerQR, startPoint: self.nosePoints[12],linePoints:linePointQR)
            //             // MARK: - 嘴下 竖 3
            for i in 2...6 {
                linePointRL.append(self.nosePoints[i])
            }
            linePointRL.append(self.mouthPoints[10])
            linePointRL.append(self.mouthPoints[11])
            linePointRL.append(self.mouthPoints[0])
            linePointRL.append(self.mouthPoints[1])
            linePointRL.append(self.mouthPoints[2])
            linePointRL.append(CGPointMake((self.faceProfilePoints[9].x + self.mouthPoints[1].x) / 2, (self.faceProfilePoints[9].y + self.mouthPoints[2].y) / 2))
            linePointPL.append(self.faceProfilePoints[8])
            //            linePointRL.append(CGPointMake((self.faceProfilePoints[9].x + self.faceProfilePoints[11].x) / 2, self.faceProfilePoints[9].y - 20))
            self.drawLine(layerRL, startPoint: self.nosePoints[2],linePoints:linePointRL)
            
            for var i = 12; i > 7;i--  {
                linePointRR.append(self.nosePoints[i])
            }
            for var i = 8; i > 3; i-- {
                linePointRR.append(self.mouthPoints[i])
            }
            linePointRR.append(CGPointMake((self.faceProfilePoints[11].x + self.mouthPoints[5].x) / 2, (self.faceProfilePoints[11].y + self.mouthPoints[4].y) / 2))
            
            linePointRR.append(CGPointMake((self.faceProfilePoints[9].x + self.mouthPoints[1].x) / 2, (self.faceProfilePoints[9].y + self.mouthPoints[2].y) / 2))
            linePointPL.append(self.faceProfilePoints[8])
            self.drawLine(layerRR, startPoint: self.nosePoints[12],linePoints:linePointRR)
            
            }) { (let error) -> Void in
                print(error)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //      扫描效果
                DataHelper.SharedDataHelper.latitude = latitude
                DataHelper.SharedDataHelper.longitude = longitude
                DataHelper.SharedDataHelper.timeString = timestring
                 DataHelper.SharedDataHelper.uploadImage(showImageUrl)

        UIView.transitionWithView(scanImage, duration: 2, options: UIViewAnimationOptions.Repeat, animations: { () -> Void in
            var frameNew = self.scanImage.frame
            frameNew.origin.y += self.scanImage.frame.size.height + 40
            self.scanImage.frame = frameNew
            self.scanImage.alpha = 0.8
            
            }) { (Bool) -> Void in
                print("?")
        }
    }
    
    func imgPoints(name:NSString,point:CGPoint) {
        let name = CALayer()
        name.frame = CGRectMake(point.x - 2,point.y - 2, 4, 4)
        name.backgroundColor = UIColor.whiteColor().CGColor
        name.masksToBounds = true
        name.cornerRadius = 2
 
        let animation:CATransition = CATransition()
        animation.delegate = self
        animation.duration = 2
        animation.type = kCATransitionFade
        name.addAnimation(animation, forKey: "")
        self.backViewForPoint.layer.addAnimation(animation, forKey: "")
        self.backViewForPoint.layer.addSublayer(name)
        
    }
    
 
    //      MARK: - 画线及画点方法
    func drawLine(layer:CAShapeLayer,startPoint:CGPoint,linePoints:[CGPoint]) {
        
  
        self.pointMuved(backViewForPoint, startPoint: startPoint, linePoints: linePoints, delay: 0, layer: layer)
        
    }
    
    
    
    // MARK: - 点移动
    func pointMuved(imageView:UIView,startPoint:CGPoint,linePoints:[CGPoint],delay:Double,layer:CAShapeLayer) {
        
        //        self.flash(pointView)
        
        let raw = UIViewKeyframeAnimationOptions.CalculationModePaced.rawValue | UIViewAnimationOptions.CurveLinear.rawValue
        let options = UIViewKeyframeAnimationOptions(rawValue: raw)
        UIView.animateKeyframesWithDuration(5, delay: delay, options: options, animations: { () -> Void in
            let path = UIBezierPath()
            path.moveToPoint(startPoint)
            for i in 0..<linePoints.count{
                path.addLineToPoint(linePoints[i])
            }
            layer.path = path.CGPath
            layer.fillColor = UIColor.clearColor().CGColor
            layer.strokeColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.75).CGColor
            self.animation1(layer)
            imageView.layer.addSublayer(layer)
            
            
            }) { (Bool) -> Void in
                
        }
        
    }
    
    
    //   MARK: - 闪烁
    func flash(flashView:UIView) {
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.Repeat, animations: { () -> Void in
            flashView.backgroundColor = UIColor.greenColor()
            
            }, completion: { (Bool) -> Void in
                
                UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                    flashView.backgroundColor = UIColor.blackColor()
                    }, completion: { (Bool) -> Void in
                        
                })
        })
    }
    // MARK: - 连线
    private func animation1(layer:CAShapeLayer) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 4
        layer.addAnimation(animation, forKey: "")
        
    }
    
    
    func keyframeAnimation(path:CGMutablePathRef,durTime:Double) ->CAKeyframeAnimation {
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.autoreverses = false
        animation.duration = durTime
        animation.repeatCount = 0
        return animation
    }
    
    func getPoints(data:NSDictionary) {
        //            计算比例
        let proportionY:CGFloat =  (backViewForPoint.frame.size.height) / (data["image_height"]! as! CGFloat)
        let proportionX:CGFloat =  (backViewForPoint.frame.size.width) / (data["image_width"]! as! CGFloat)
        
        
        for i in 0...7 {
            leftEyePoints += [CGPointMake(CGFloat(self.faceModel.left_eye[i]["x"]!! as! NSNumber) * proportionX,CGFloat(self.faceModel.left_eye[i]["y"]!! as! NSNumber) * proportionY)]
            
            
            leftEyeBlowPoints += [CGPointMake(CGFloat(self.faceModel.left_eyebrow[i]["x"]! as! NSNumber) * proportionX,CGFloat(self.faceModel.left_eyebrow[i]["y"]! as! NSNumber) * proportionY)]
            
            rightEyePoints += [CGPointMake(CGFloat(self.faceModel.right_eye[i]["x"]!! as! NSNumber) * proportionX,CGFloat(self.faceModel.right_eye[i]["y"]!! as! NSNumber) * proportionY)]
            rightEyeBlowPoints += [CGPointMake(CGFloat(self.faceModel.right_eyebrow[i]["x"]!! as! NSNumber) * proportionX,CGFloat(self.faceModel.right_eyebrow[i]["y"]!! as! NSNumber) * proportionY)]
            
        }
        
        for i in 0...12 {
            nosePoints += [CGPointMake(CGFloat(self.faceModel.nose[i]["x"]!! as! NSNumber) * proportionX,CGFloat(self.faceModel.nose[i]["y"]!! as! NSNumber) * proportionY)]
        }
        
        for i in 0...21 {
            mouthPoints += [CGPointMake(CGFloat(self.faceModel.mouth[i]["x"]!! as! NSNumber) * proportionX,CGFloat(self.faceModel.mouth[i]["y"]!! as! NSNumber) * proportionY)]
            
        }
        
        for i in 0...20 {
            faceProfilePoints += [CGPointMake(CGFloat(self.faceModel.face_profile![i]["x"]!! as! NSNumber) * proportionX,CGFloat(self.faceModel.face_profile![i]["y"]!! as! NSNumber) * proportionY)]
            
        }
        
        
    }
    
    func funcChangedtoA() {
        
        self.changeText.text = "a"

    }
    func funcChangedtoB() {
        
        self.changeText.text = "b"
        
    }
    func funcChangedtoC() {
        
        self.changeText.text = "c"
        
    }
    func funcChangedtoD() {
        
        self.changeText.text = "d"
        
    }
    func funcChangedtoE() {
        
        self.changeText.text = "e"
        
    }
    func funcChangedtoF() {
        
        self.changeText.text = "f"
        
    }
    

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
         if keyPath == "text" {
          
            if changeText.text == "a"{
             
                self.analysisLabel.text = "正在检测肌肤年龄..."
            }
            if changeText.text == "b"{
                
                self.analysisLabel.text = "正在定位面部位置..."
            }
            if changeText.text == "c"{
                
                self.analysisLabel.text = "正在分析黑头..."
            }
            if changeText.text == "d"{
                
                self.analysisLabel.text = "严重程度..."
            }
            
            if changeText.text == "e"{
                
                self.analysisLabel.text = "正在识别出油范围..."
            }
            if changeText.text == "f"{
                
                self.analysisLabel.text = "正在检测毛孔"
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        self.latitude = manager.location!.coordinate.latitude.description
        self.longitude = manager.location!.coordinate.longitude.description
        //latitide.description
        self.locationManager.stopUpdatingLocation()
        print("latitude is \(latitude!) longitude is \(longitude!)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Error: " + error.localizedDescription)
    }
   

    
    deinit {
        
        self.changeText.removeObserver("text", forKeyPath: "")
    }
    
    @IBAction func jumpAction(sender: UIButton) {
       let array =  PictureModel.mj_objectArrayWithKeyValuesArray([["year":2016,"month":3,"day":3,"picArray":["CalendarSelectedDate"]],["year":2016,"month":4,"day":3,"picArray":["CalendarSelectedDate","CalendarSelectedDate","CalendarSelectedDate"]]])
        let callendarViewController:CalendarViewController = CalendarViewController.calendarWithDays(366, showType: CalendarShowType.Multiple, modelArrar: array)
        self.presentViewController(callendarViewController, animated: true) { () -> Void in
 self.showDetailViewController(callendarViewController, sender: nil)
        }
    }
    
    
   
}
private extension UIImage {
    func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI) * 0.01
//
//
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width, rotatedSize.height);
        
        //   // Rotate the image context
        CGContextRotateCTM(bitmap, degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        CGContextScaleCTM(bitmap, yFlip, -1.0)
        
        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 1.7, size.width , size.height), CGImage)
//        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func areaAverage() -> UIColor {
        var bitmap = [UInt8](count: 4, repeatedValue: 0)
        
        if #available(iOS 9.0, *) {
            // Get average color.
            let context = CIContext()
            let inputImage = CIImage ?? CoreImage.CIImage(CGImage: CGImage!)
            let extent = inputImage.extent
            let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
            let filter = CIFilter(name: "CIAreaAverage", withInputParameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
            let outputImage = filter.outputImage!
            let outputExtent = outputImage.extent
            assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)
            
            // Render to bitmap.
            context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        } else {
            // Create 1x1 context that interpolates pixels when drawing to it.
            let context = CGBitmapContextCreate(&bitmap, 1, 1, 8, 4, CGColorSpaceCreateDeviceRGB(), CGBitmapInfo.ByteOrderDefault.rawValue | CGImageAlphaInfo.PremultipliedLast.rawValue)!
            let inputImage = CGImage ?? CIContext().createCGImage(CIImage!, fromRect: CIImage!.extent)
            
            // Render to bitmap.
            CGContextDrawImage(context, CGRect(x: 0, y: 0, width: 1, height: 1), inputImage)
        }
        
        // Compute result.
        let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        return result
    }
    
 
    
    func cutImage(image:UIImage,rect:CGRect) -> UIImage{
        
        let imageRef = CGImageCreateWithImageInRect(image.CGImage, rect)
        let newImg = UIImage(CGImage: imageRef!)
        return newImg
    
    }
}

 