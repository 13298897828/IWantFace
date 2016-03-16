//
//  CameraViewController.swift
//  WantFace
//
//  Created by 张天琦 on 16/3/4.
//  Copyright © 2016年 YiXi. All rights reserved.
//

import UIKit
//import SwiftHTTP


class CameraViewController: UIViewController {
typealias changeClouse = () -> Void
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var bgView1: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var pointA: UIView!
    @IBOutlet weak var pointB: UIView!
    let cornerImageView:UIImageView = UIImageView()
    let cgClouse = changeClouse?()
    private var visage:Visage?
     private let notificationCenter : NSNotificationCenter = NSNotificationCenter.defaultCenter()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(bgView1)
 
//        self.view.backgroundColor = UIColor.blackColor()
        self.bgView1.alpha = 0
        _ = NSTimer.scheduledTimerWithTimeInterval(3,
            target:self,selector:Selector("funcFlash"),
            userInfo:nil,repeats:true)

        UIScreen.mainScreen().brightness = 1
        _ = NSTimer.scheduledTimerWithTimeInterval(3,
            target:self,selector:Selector("funcFlashGreen"),
            userInfo:nil,repeats:true)
        cornerImageView.frame = CGRectMake(20, 20, self.cameraView.bounds.size.width - 40, cameraView.bounds.size.width - 40)
        cornerImageView.image = UIImage(named: "focus")
        cameraView.sizeToFit()
        self.cameraView.addSubview(cornerImageView)

        visage = Visage(cameraPosition: Visage.CameraDevice.ISightCamera, optimizeFor: Visage.DetectorAccuracy.HigherPerformance)
        visage?.blockss = {
            
            self.bgView1.alpha = 1
        }
        visage?.blockno = {
            
            self.bgView1.alpha = 0
        }
        
        //If you enable "onlyFireNotificationOnStatusChange" you won't get a continuous "stream" of notifications, but only one notification once the status changes.
        visage!.onlyFireNotificatonOnStatusChange = false
        
        //You need to call "beginFaceDetection" to start the detection, but also if you want to use the cameraView.
        visage!.beginFaceDetection()
        
        //This is a very simple cameraView you can use to preview the image that is seen by the camera.
        let cameraViewFormVigage = visage!.visageCameraView
//        cameraViewFormVigage.frame = CGRectMake(0, 0, cameraView.frame.size.width, cameraView.frame.size.width)
        
        pointA.layer.cornerRadius = 4
        pointA.layer.masksToBounds = true
        pointB.layer.cornerRadius = 4
        pointB.layer.masksToBounds = true
        cameraView.addSubview(cameraViewFormVigage)
        self.cameraView.bringSubviewToFront(cornerImageView)
        NSNotificationCenter.defaultCenter().addObserverForName("visageTakenPictureNotification", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            
            if (self.visage!.didTakePicture == true){
                print("get take picture notification in view controller")
      
                let SCController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ScanViewController") as! ScanViewController
                SCController.showImageUrl = self.visage!.url
                self.showDetailViewController(SCController, sender: nil)
//                self.showViewController(SCController, sender: nil)
            }
        })
        
        
 
 

    }
    func funcFlash() ->Void{
        
        UIView.animateWithDuration(1.5, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            self.bgView.backgroundColor = UIColor.redColor()
            
            }, completion: { (Bool) -> Void in
                
                UIView.animateWithDuration(1.5, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                     
                    self.bgView.backgroundColor = UIColor.blackColor()
                    }, completion: { (Bool) -> Void in
                        
                })
        })
        
        
    }
    //     // MARK: - 闪灯
    func funcFlashGreen() ->Void{
        
        UIView.animateWithDuration(1.5, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            self.bgView1.backgroundColor = UIColor.greenColor()
            
            }, completion: { (Bool) -> Void in
                
                UIView.animateWithDuration(1.5, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                    self.bgView1.backgroundColor = UIColor.blackColor()
                    }, completion: { (Bool) -> Void in
                        
                })
        })
        
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        visage!.endFaceDetection()
        UIScreen.mainScreen().brightness = 0.5
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
