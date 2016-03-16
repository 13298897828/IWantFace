//
//  StateViewController.swift
//  IWantFace
//
//  Created by 张天琦 on 16/3/8.
//  Copyright © 2016年 C2H4. All rights reserved.
//

import UIKit
let ImgHeight:CGFloat = 160
typealias ChangeAplha = (alpha:Float) -> ()
class StateViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var topImgView: UIImageView!
    var backView:UIView = UIView()
    var backColor:UIColor = UIColor()
    var changeAplha:ChangeAplha?
 
    @IBOutlet weak var skinAgeLoop: SDPieLoopProgressView!
    @IBOutlet weak var totalScore: SDPieLoopProgressView!
//    用来拼接的分享视图
    var shareTopImg = UIImage()
    var shareBottomImg = UIImage()
    
    @IBOutlet weak var firstCircle: UIImageView!
    @IBOutlet weak var secondCircle: UIImageView!
    @IBOutlet weak var secondShareLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrolView.contentInset = UIEdgeInsetsMake(ImgHeight, 0, 0, 0)
//      navigationBar变色
        backView.backgroundColor = backColor .colorWithAlphaComponent(0.3)
        backView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 41))
        backColor = UIColor.blackColor()
        skinAgeLoop.tintColor = UIColor.redColor()
        skinAgeLoop.progress = 0.1
 
        

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
        
//        pageControl.currentPage =  Int(sharedScrollView.contentOffset.x / Width)
        
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


