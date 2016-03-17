//
//  StateViewController.swift
//  IWantFace
//
//  Created by 张天琦 on 16/3/8.
//  Copyright © 2016年 C2H4. All rights reserved.
//

import UIKit
import pop
let ImgHeight:CGFloat = 160
typealias ChangeAplha = (alpha:Float) -> ()
class StateViewController: UIViewController,UIScrollViewDelegate {
    let Width = UIScreen.mainScreen().bounds.width
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var topImgView: UIImageView!
    var backView:UIView = UIView()
    var backColor:UIColor = UIColor()
    var changeAplha:ChangeAplha?
//    四项检测结果
    @IBOutlet weak var numOfBlacks: UILabel!
//    严重程度
    @IBOutlet weak var severity: UILabel!
//    毛孔
    @IBOutlet weak var numOfPore: UILabel!
//    光滑度
    @IBOutlet weak var eggImgView: UIImageView!
    @IBOutlet weak var questionMarkImgView: UIImageView!
    
    @IBOutlet weak var smoothDegreeOfSkin: UILabel!
//   脸图片
    @IBOutlet weak var faceImgView: UIImageView!
//    三个围绕图
    @IBOutlet weak var circleOfCheek: UIImageView!
    @IBOutlet weak var circleOfChin: UIImageView!
    @IBOutlet weak var circleOfT: UIImageView!
//    统计图
    @IBOutlet weak var statisticalImgView: UIImageView!
    @IBOutlet weak var TLabel: UILabel!
    @IBOutlet weak var cheekLabel: UILabel!
    @IBOutlet weak var chinLabel: UILabel!
 
    @IBOutlet weak var circle1: UIImageView!
    @IBOutlet weak var circle2: UIImageView!
    @IBOutlet weak var circle3: UIImageView!
    @IBOutlet weak var circle4: UIImageView!
    @IBOutlet weak var circle5: UIImageView!
    @IBOutlet weak var circle6: UIImageView!
    @IBOutlet weak var circle7: UIImageView!
    @IBOutlet weak var circle8: UIImageView!
 
    @IBOutlet weak var ageSkinLoop: SDLoopProgressView!
    @IBOutlet weak var totalScoreLoop: SDLoopProgressView!
    @IBOutlet weak var shareScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var shareButton: UIButton!

    let layerA = CAShapeLayer()
    let layerT = CAShapeLayer()
    let layerC = CAShapeLayer()
    let layerD = CAShapeLayer()
  
//    用来拼接的分享视图
    var shareTopImg = UIImage()
    var shareBottomImg = UIImage()
    
    @IBOutlet weak var firstCircle: UIImageView!
    @IBOutlet weak var secondCircle: UIImageView!
    @IBOutlet weak var secondShareLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrolView.contentInset = UIEdgeInsetsMake(ImgHeight, 0, 0, 0)
        backView.backgroundColor = backColor .colorWithAlphaComponent(0.3)
        backView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 41))
        backColor = UIColor.blackColor()
        ageSkinLoop.progress = 0.6
        shareScrollView.delegate = self
        dealWithShareLabelText()
        faceImgView.alpha = 0
        addAnimationForCircle()
        addPopAnimation(circleOfT)
        addPopAnimation(circleOfCheek)
        addPopAnimation(circleOfChin)
      
//      脸颊
        
        let pointForCheekA = CGPointMake(-30, 80)
        let pointForCheekB = CGPointMake(26,80)
        let pointForCheekC = CGPointMake(54, 122)
        let pointForCheekD = CGPointMake(200, 122)
        
//      T区
        var pointForTA =  CGPointMake(faceImgView.frame.size.width / 10 * 9, 80)
        var pointForTB =  CGPointMake(faceImgView.frame.size.width / 10 * 3.36, 80)
        
        
//      下巴
       var pointForChinA = CGPointMake(0,faceImgView.frame.size.height / 5 * 3.1)
       var pointForChinB = CGPointMake(faceImgView.frame.size.width / 2.83, faceImgView.frame.size.height / 5 * 3.1)
        
        if Width == 375 {
            pointForTA.x = pointForTA.x * 375.0 / 414.0
            pointForTA.y = pointForTA.y * 375.0 / 414.0
            pointForTB.x = pointForTB.x * 375.0 / 414.0
            pointForTB.y = pointForTB.y * 375.0 / 414.0
            pointForChinA.y = pointForChinA.y * 375.0 / 414.0
            pointForChinB.x = pointForChinB.x * 375.0 / 414.0
            pointForChinB.y = pointForChinB.y * 375.0 / 414.0

        }
        if Width == 320 {
            pointForTA.x = pointForTA.x * 320.0 / 414.0
            pointForTA.y = pointForTA.y * 320.0 / 414.0
            pointForTB.x = pointForTB.x * 320.0 / 414.0
            pointForTB.y = pointForTB.y * 320.0 / 414.0
            pointForChinA.y = pointForChinA.y * 320.0 / 414.0
            pointForChinB.x = pointForChinB.x * 320.0 / 414.0
            pointForChinB.y = pointForChinB.y * 320.0 / 414.0
       
        }
//        脸颊
        pointMuved(faceImgView, startPoint: pointForCheekA, linePoints: [pointForCheekB,pointForCheekC], delay: 0, layer: layerC)
        pointMuved(faceImgView, startPoint: pointForCheekA, linePoints: [pointForCheekB,pointForCheekD], delay: 0, layer: layerD)
        pointMuved(faceImgView, startPoint: pointForTA, linePoints: [pointForTB], delay: 0, layer: layerT)
        pointMuved(faceImgView, startPoint:pointForChinA, linePoints: [pointForChinB], delay: 0, layer: layerA)
 
        
    }
    func addAnimationForCircle() {
        UIView.transitionWithView(circleOfCheek, duration: 1, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
             self.faceImgView.alpha = 1
            }) { (Bool) -> Void in
                
        }
    }
    
    func drawLine(imgView:UIImageView,layer:CAShapeLayer,startPoint:CGPoint,linePoints:[CGPoint]) {
        
        //   添加点的位置
        //        pointView.frame = CGRectMake(startPoint.x - 5, startPoint.y - 5, 10, 10)
        //        self.imgView.addSubview(self.pointView)
        //   画线
        //        self.pointMuved(startPoint: startPoint,linePoints:linePoints,delay: 0,layer: layer)
        self.pointMuved(imgView, startPoint: startPoint, linePoints: linePoints, delay: 0, layer: layer)
        
    }
 
    func pointMuved(imageView:UIImageView,startPoint:CGPoint,linePoints:[CGPoint],delay:Double,layer:CAShapeLayer) {
        
        let raw = UIViewKeyframeAnimationOptions.CalculationModePaced.rawValue | UIViewAnimationOptions.CurveLinear.rawValue
        let options = UIViewKeyframeAnimationOptions(rawValue: raw)
        UIView.animateKeyframesWithDuration(5, delay: delay, options: options, animations: { () -> Void in
            let path = UIBezierPath()
            path.moveToPoint(startPoint)
            print(startPoint)
                        print(linePoints[0])
            for i in 0..<linePoints.count{
                path.addLineToPoint(linePoints[i])
            }
            layer.path = path.CGPath
            layer.fillColor = UIColor.clearColor().CGColor
            layer.strokeColor = UIColor.redColor().CGColor
//                UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.75).CGColor
            self.animation1(layer)
            imageView.layer.addSublayer(layer)
            
            
            }) { (Bool) -> Void in
                
        }
        
    }
    
    private func animation1(layer:CAShapeLayer) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 4
        layer.addAnimation(animation, forKey: "")
        
    }
 
    func addPopAnimation(view:UIView) {
        
        let opacityAnimation = POPBasicAnimation(propertyNamed:kPOPLayerOpacity)
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        opacityAnimation.beginTime = CACurrentMediaTime() + 0.5
        view.layer.pop_animationForKey("showOpacityAnimation")
        let scaleAnimation  = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnimation.fromValue = NSValue(CGSize:CGSizeMake(0.1, 0.1))
        scaleAnimation.toValue = NSValue(CGSize:CGSizeMake(1.0, 1.0))
        scaleAnimation.springBounciness = 20.0
        scaleAnimation.springSpeed = 20.0
        view.layer.pop_addAnimation(scaleAnimation, forKey: "showScaleAnimation")
    }

// MARK: -   处理分享文字样式
    func dealWithShareLabelText() {
        //        分享文字
        var text = String()
        text = "你的肌肤光滑度超过了全杭州71%的女生,综合得分排名靠前"
        let text3 = NSMutableAttributedString(string: text)
        //        改颜色
        let needle: Character = "%"
        if let idx = text.characters.indexOf(needle) {
            let pos = text.startIndex.distanceTo(idx)
            //            print("Found \(needle) at position \(pos)")
            text3.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 254 / 255.0, green: 220 / 255.0, blue: 98 / 255.0, alpha: 1), range: NSMakeRange(pos - 2, 3))
            print(pos,idx)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 10
            style.alignment = NSTextAlignment.Center
            text3.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, text3.length))
            secondShareLabel.attributedText = text3
        }
        else {
            print("Not found")
        }
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let y:CGFloat = scrollView.contentOffset.y
        print(y)
        let alpha = (y + 40)/400.0
        self.changeAplha?(alpha: Float(alpha))
        backView.backgroundColor = self.backColor.colorWithAlphaComponent(alpha)
        if y < 100 {
            var frame:CGRect = topImgView.frame
            frame.origin.y = y
            frame.size.height = -y * 1.03
            topImgView.frame = frame
            topImgView.contentMode = UIViewContentMode.ScaleAspectFill

        }
        
        if y == 10{

            self.shareTopImg = getImage()
            
        }
        if y == 273 {
            
        }
    }
//  // MARK: - pageControl
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        pageControl.currentPage =  Int(shareScrollView.contentOffset.x / Width)
        
    }
  
    @IBAction func shareAction(sender: UIButton) {
        print(shareScrollView.contentOffset.x)
    }
    
    override func viewDidAppear(animated: Bool) {
        let con =  self.view.superview!.superview!.superview!.superview!.superview!.superview!.nextResponder()! as!ContainViewController
        con.navigationController?.navigationBar.addSubview(backView)
        con.navigationController?.navigationBar.sendSubviewToBack(backView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
  
        
    }
    
    
 
//    // MARK: -  截屏幕
    func getImage() -> (UIImage){
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.height), false, 1.0)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    

}



//  MARK: - index 转 int
extension String {
    public func indexOfCharacter(char: Character) -> Int? {
        if let idx = self.characters.indexOf(char) {
            return self.startIndex.distanceTo(idx)
        }
        return nil
    }
}


