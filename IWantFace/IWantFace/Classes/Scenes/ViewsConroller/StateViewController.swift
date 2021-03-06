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
class StateViewController: UIViewController,UIScrollViewDelegate,UIPageViewControllerDelegate,POPAnimationDelegate {
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
    @IBOutlet weak var firstPillar: UIView!
    @IBOutlet weak var firstPillBg: UIView!
    
    @IBOutlet weak var secondPillar: UIView!
    @IBOutlet weak var secondPillBg: UIView!
    
    @IBOutlet weak var thirdPillar: UIView!
    @IBOutlet weak var thirdPillBg: UIView!
    
    @IBOutlet weak var firstPillImgView: UIImageView!
    @IBOutlet weak var secondPillImgView: UIImageView!
    @IBOutlet weak var thirdPillImgView: UIImageView!
    let firstPillLabel = UILabel(frame:CGRectMake(5, 0, 30, 20))
    let secondPillLabel = UILabel(frame:CGRectMake(5, 0, 30, 20))
    let thirdPillLabel = UILabel(frame:CGRectMake(5, 0, 30, 20))
    
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
    @IBOutlet weak var shareContentView: UIView! // 容器
    
    let layerA = CAShapeLayer()
    let layerT = CAShapeLayer()
    let layerC = CAShapeLayer()
    let layerD = CAShapeLayer()
    var pointForCheekA = CGPoint()
    var pointForCheekB = CGPoint()
    var pointForCheekC = CGPoint()
    var pointForCheekD = CGPoint()
    var pointForTA =  CGPoint()
    var pointForTB =  CGPoint()
    //      下巴
    var pointForChinA = CGPoint()
    var pointForChinB = CGPoint()
    //    用来拼接的分享视图
    var shareTopImg = UIImage()
    var shareBottomImg = UIImage()
    
    @IBOutlet weak var firstCircle: UIImageView!
    @IBOutlet weak var secondCircle: UIImageView!
    @IBOutlet weak var secondShareLabel: UILabel!
    @IBOutlet weak var bigNum: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getValues()
        setViews()
        addAnimationForCircle()
        addLine()
        scrolView.tag = 100
    }
    
    // MARK: - 背景设置及代理
    func setViews() {
        scrolView.contentInset = UIEdgeInsetsMake(ImgHeight, 0, 0, 0)
        backView.backgroundColor = backColor .colorWithAlphaComponent(0.3)
        backView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 41))
        backColor = UIColor.blackColor()
        shareScrollView.delegate = self
        dealWithShareLabelText()
        faceImgView.alpha = 0
        
    }
    // MARK: - 赋值
    func getValues() {
        let analyFace = DataHelper.SharedDataHelper.analyseModel
        numOfBlacks.text = analyFace.blackhead_number
        severity.text =  analyFace.blackhead_severity
        numOfPore.text = analyFace.pore_severity
        eggImgView.image = UIImage(named: analyFace.coarseness)
        smoothDegreeOfSkin.text = analyFace.coarseness
        faceImgView.image = UIImage(named: analyFace.gender)
        let n =  NSNumberFormatter().numberFromString(analyFace.skin_age)
        let age = CGFloat(n!)
        ageSkinLoop.progress = age / 100
        let temp = NSNumberFormatter().numberFromString(analyFace.total_score)
        let score = CGFloat(temp!)
        totalScoreLoop.progress = score / 100
        switch analyFace.skin_color {
        case "1":
            circle1.image = UIImage(named: "bigCircle")
            circle1.contentMode = UIViewContentMode.Bottom
        case "2":
            circle2.image = UIImage(named: "bigCircle")
            circle2.contentMode = UIViewContentMode.Bottom
        case "3":
            circle3.image = UIImage(named: "bigCircle")
            circle3.contentMode = UIViewContentMode.Bottom
        case "4":
            circle4.image = UIImage(named: "bigCircle")
            circle4.contentMode = UIViewContentMode.Bottom
        case "5":
            circle5.image = UIImage(named: "bigCircle")
            circle5.contentMode = UIViewContentMode.Bottom
        case "6":
            circle6.image = UIImage(named: "bigCircle")
            circle6.contentMode = UIViewContentMode.Bottom
        case "7":
            circle7.image = UIImage(named: "bigCircle")
            circle7.contentMode = UIViewContentMode.Bottom
        default:
            circle8.image = UIImage(named: "bigCircle")
            circle8.contentMode = UIViewContentMode.Bottom
            

//
            
            
        }
        
    }
    // MARK: - 添加label
    func addPillSubView(labelText:String,label:UILabel,superView:UIView) {
        
        label.text = "\(labelText)\("%")"
        label.frame = CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height)
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(13)
        superView.addSubview(label)
        label.textColor = UIColor.whiteColor()

    }
    // MARK: - 画线
    private func addLine() {
        //      脸颊
        
        pointForCheekA = CGPointMake(-35, 90)
        pointForCheekB = CGPointMake(26,90)
        pointForCheekC = CGPointMake(59, 134)
        pointForCheekD = CGPointMake(127, 134)
        
        //      T区
        pointForTA =  CGPointMake(faceImgView.frame.size.width / 10 * 9 - 36, 81)
        pointForTB =  CGPointMake(faceImgView.frame.size.width / 10 * 3.36, 81)
        
        
        //      下巴
        pointForChinA = CGPointMake(25,faceImgView.frame.size.height / 5 * 3.1)
        pointForChinB = CGPointMake(faceImgView.frame.size.width / 2.83, faceImgView.frame.size.height / 5 * 3.1)
        
        if Width == 375 {
            pointForTA.x = pointForTA.x * 375.0 / 414.0
            pointForTA.y = pointForTA.y * 375.0 / 414.0
            pointForTB.x = pointForTB.x * 375.0 / 414.0
            pointForTB.y = pointForTB.y * 375.0 / 414.0
            pointForChinA.y = pointForChinA.y * 375.0 / 414.0
            pointForChinB.x = pointForChinB.x * 375.0 / 414.0
            pointForChinB.y = pointForChinB.y * 375.0 / 414.0
            pointForCheekA.x = pointForCheekA.x * 375.0 / 414.0
            pointForCheekA.y = pointForCheekA.y * 375.0 / 414.0
            pointForCheekB.x = pointForCheekB.x * 375.0 / 414.0
            pointForCheekB.y = pointForCheekB.y * 375.0 / 414.0
            pointForCheekC.x = pointForCheekC.x * 375.0 / 414.0
            pointForCheekC.y = pointForCheekC.y * 375.0 / 414.0
            pointForCheekD.x = pointForCheekD.x * 375.0 / 414.0
            pointForCheekD.y = pointForCheekD.y * 375.0 / 414.0
            
        }
        if Width == 320 {
            pointForTA.x = pointForTA.x * 320.0 / 414.0
            pointForTA.y = pointForTA.y * 320.0 / 414.0
            pointForTB.x = pointForTB.x * 320.0 / 414.0
            pointForTB.y = pointForTB.y * 320.0 / 414.0
            pointForChinA.y = pointForChinA.y * 320.0 / 414.0
            pointForChinB.x = pointForChinB.x * 320.0 / 414.0
            pointForChinB.y = pointForChinB.y * 320.0 / 414.0
            pointForCheekA.x = pointForCheekA.x * 320.0 / 414.0
            pointForCheekA.y = pointForCheekA.y * 320.0 / 414.0
            pointForCheekB.x = pointForCheekB.x * 320.0 / 414.0
            pointForCheekB.y = pointForCheekB.y * 320.0 / 414.0
            pointForCheekC.x = pointForCheekC.x * 320.0 / 414.0
            pointForCheekC.y = pointForCheekC.y * 320.0 / 414.0
            pointForCheekD.x = pointForCheekD.x * 320.0 / 414.0
            pointForCheekD.y = pointForCheekD.y * 320.0 / 414.0
            
            
        }
        //        脸颊
        pointMuved(faceImgView, startPoint: pointForCheekA, linePoints: [pointForCheekB,pointForCheekC], delay: 0, layer: layerC,red: 22, green: 165,blue: 175)
        pointMuved(faceImgView, startPoint: pointForCheekA, linePoints: [pointForCheekB,pointForCheekD], delay: 0, layer: layerD,red: 22, green: 165,blue: 175)
        
        
        
        
    }
    // MARK: -  人脸图及三个圈
    private func addAnimationForCircle() {
        UIView.transitionWithView(circleOfCheek, duration: 1, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.faceImgView.alpha = 1
            }) { (Bool) -> Void in
                
        }
        //      圈延时出现
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(StateViewController.timerT), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(StateViewController.timerChin), userInfo: nil, repeats: false)
        
        addPopAnimation(circleOfCheek)
        circleOfT.hidden = true
        circleOfChin.hidden = true
    }
    func timerChin() {
        
        circleOfChin.hidden = false
        addPopAnimation(circleOfChin)
        pointMuved(faceImgView, startPoint:pointForChinA, linePoints: [pointForChinB], delay: 1, layer: layerA, red: 254, green: 220,blue:  98)
    }
    func timerT() {
        circleOfT.hidden = false
        addPopAnimation(circleOfT)
        pointMuved(faceImgView, startPoint: pointForTA, linePoints: [pointForTB], delay: 3, layer: layerT ,red: 0, green: 0,blue: 0)
    }
    // MARK: - 点移动
    private func pointMuved(imageView:UIImageView,startPoint:CGPoint,linePoints:[CGPoint],delay:Double,layer:CAShapeLayer,red:Float,green:Float,blue:Float) {
        
        let raw = UIViewKeyframeAnimationOptions.CalculationModePaced.rawValue | UIViewAnimationOptions.CurveLinear.rawValue
        let options = UIViewKeyframeAnimationOptions(rawValue: raw)
        UIView.animateKeyframesWithDuration(2, delay: delay, options: options, animations: { () -> Void in
            let path = UIBezierPath()
            path.lineWidth = 1
            path.moveToPoint(startPoint)
            
            for i in 0..<linePoints.count{
                path.addLineToPoint(linePoints[i])
            }
            layer.path = path.CGPath
            layer.fillColor = UIColor.clearColor().CGColor
            layer.strokeColor = UIColor(colorLiteralRed: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1).CGColor
            self.animation1(layer)
            imageView.layer.addSublayer(layer)
            
            
            }) { (Bool) -> Void in
                
        }
        
    }
    private func animation1(layer:CAShapeLayer) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        layer.addAnimation(animation, forKey: "")
        
    }
    
    private func addPopAnimation(view:UIView) {
        
        let opacityAnimation = POPBasicAnimation(propertyNamed:kPOPLayerOpacity)
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        opacityAnimation.beginTime = CACurrentMediaTime() + 0.5
        view.layer.pop_animationForKey("showOpacityAnimation")
        let scaleAnimation  = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnimation.fromValue = NSValue(CGSize:CGSizeMake(0.1, 0.1))
        scaleAnimation.toValue = NSValue(CGSize:CGSizeMake(1.0, 1.0))
        scaleAnimation.springBounciness = 20.0
        scaleAnimation.springSpeed = 10.0
        view.layer.pop_addAnimation(scaleAnimation, forKey: "showScaleAnimation")
        
    }
    // MARK: -   处理分享文字样式
    private func dealWithShareLabelText() {
        //        分享文字
        var text = String()
       
        text = "你的肌肤光滑度超过了全国81%的女生"
        let text3 = NSMutableAttributedString(string: text)
        //        改颜色
        let needle: Character = "%"
        if let idx = text.characters.indexOf(needle) {
            let pos = text.startIndex.distanceTo(idx)
            //            print("Found \(needle) at position \(pos)")
            text3.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 254 / 255.0, green: 220 / 255.0, blue: 98 / 255.0, alpha: 1), range: NSMakeRange(pos - 2, 3))
          
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
        if scrollView.tag == 100 {
            
            let y:CGFloat = scrollView.contentOffset.y
            //        print(y)
            let alpha = (y + 40)/400.0
            self.changeAplha?(alpha: Float(alpha))
            backView.backgroundColor = self.backColor.colorWithAlphaComponent(alpha)
            if y < 100 {
                var frame:CGRect = topImgView.frame
                frame.origin.y = y
                frame.size.height = -y * 1.03
                topImgView.frame = frame
                topImgView.contentMode = UIViewContentMode.ScaleAspectFill
                if y == 10{
                    
                    self.shareTopImg = getImage()
                    
                }
                if y == 273 {
                    
                }
                
            }
            
        }
        
        
        
       
    }
    //  // MARK: - pageControl
     func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        pageControl.currentPage =  Int(shareScrollView.contentOffset.x / Width)
        print(pageControl.currentPage)
        
    }
    
    @IBAction func shareAction(sender: UIButton) {
        print(shareScrollView.contentOffset.x)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
        let con =  self.view.superview!.superview!.superview!.superview!.superview!.superview!.nextResponder()! as! ContainViewController
        con.navigationController?.navigationBar.addSubview(backView)
        con.navigationController?.navigationBar.sendSubviewToBack(backView)
        if Width == 320 {
            UIView.transitionWithView(secondShareLabel, duration: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                var frame = self.secondShareLabel.frame
                frame.origin.y -= 14
                self.secondShareLabel.frame = frame
                }, completion: { (Bool) -> Void in
                    
            })
            UIView.transitionWithView(bigNum, duration: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                var frame = self.bigNum.frame
                frame.origin.y -= 18
                self.bigNum.frame = frame
                }, completion: { (Bool) -> Void in
                    
            })
            UIView.transitionWithView(symbolLabel, duration: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                var frame = self.symbolLabel.frame
                frame.origin.y -= 18
                self.symbolLabel.frame = frame
                }, completion: { (Bool) -> Void in
                    
            })
            UIView.transitionWithView(pageControl, duration: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                var frame = self.pageControl.frame
                frame.origin.y += 50
                self.pageControl.frame = frame
                }, completion: { (Bool) -> Void in
                    
            })
            UIView.transitionWithView(shareButton, duration: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                var frame = self.shareButton.frame
                frame.origin.y += 50
                self.shareButton.frame = frame
                }, completion: { (Bool) -> Void in
                    
            })
            
            
        }
        
//     百分比
        addPillSubView(String(Int(Float(DataHelper.SharedDataHelper.analyseModel.cheek_oil_shine)! * 100)), label: firstPillLabel, superView: firstPillImgView)
        addPillSubView(String(Int(Float(DataHelper.SharedDataHelper.analyseModel.Tzone_oil_shine)!  * 100)), label: secondPillLabel, superView: secondPillImgView)
        addPillSubView(String(Int(Float(DataHelper.SharedDataHelper.analyseModel.chin_oil_shine)! * 100)), label: thirdPillLabel, superView: thirdPillImgView)
//    动画
        
        pillAnimayion(firstPillar,viewA:firstPillImgView,offset:  DataHelper.SharedDataHelper.analyseModel.cheek_oil_shine)
        
        pillAnimayion(secondPillar,viewA:secondPillImgView ,offset:DataHelper.SharedDataHelper.analyseModel.Tzone_oil_shine)
        
        pillAnimayion(thirdPillar,viewA:thirdPillImgView ,offset:  DataHelper.SharedDataHelper.analyseModel.chin_oil_shine)
        
    }
 
    func pillAnimayion(view:UIView,viewA:UIView,offset:String)  {
        let pillBGHeight =  secondPillBg.frame.size.height - 10
        let n =  NSNumberFormatter().numberFromString(offset)
        let contentoffset = CGFloat(n!)
        UIView.transitionWithView(view, duration: 2, options: UIViewAnimationOptions.TransitionNone, animations: {
          
            view.frame.size.height +=  contentoffset * pillBGHeight
            view.frame.origin.y -= contentoffset * pillBGHeight
            
        }) { (Bool) in
            
        }
        UIView.transitionWithView(viewA, duration: 2, options: UIViewAnimationOptions.TransitionNone, animations: {
            viewA.frame.origin.y -= contentoffset * pillBGHeight
        }) { (Bool) in
            
        }
        
        
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


