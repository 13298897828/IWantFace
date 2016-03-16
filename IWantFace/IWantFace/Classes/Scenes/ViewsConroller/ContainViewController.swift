//
//  ContainViewController.swift
//  IWantFace
//
//  Created by 张天琦 on 16/3/9.
//  Copyright © 2016年 C2H4. All rights reserved.
//

import UIKit

class ContainViewController: UIViewController,SegmentTapViewDelegate,FlipTableViewDelegate,UINavigationControllerDelegate {
    let screen = UIScreen.mainScreen().bounds.size
    var segment :SegmentTapView = SegmentTapView()
    let stateViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StateViewController")
    let tendViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TendViewController")
    var flipView:FlipTableView = FlipTableView()
    var controllsArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
                self.navigationController?.navigationBar.translucent = true
//  切换条
        segment = SegmentTapView(frame: CGRectMake(screen.width / 4, 0, screen.width / 2, 40), withDataArray: ["状态","护理"], withFont: 15)
        segment.textNomalColor = UIColor.whiteColor()
        segment.textSelectedColor = UIColor.whiteColor()
        segment.lineColor = UIColor(red: 178 / 255.0, green: 156 / 255.0, blue: 121 / 255.0, alpha: 1)
        self.navigationController?.navigationBar.addSubview(segment)
        controllsArray.addObject(stateViewController)
        controllsArray.addObject(tendViewController)
        flipView = FlipTableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height ), withArray: controllsArray as [AnyObject])
        flipView.delegate = self
        segment.delegate = self
        self.view.addSubview(self.flipView)
        self.navigationController?.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
 
    }
    
   
 
    
    func selectedIndex(index: Int) {
        self.flipView.selectIndex(index)
    }
    func scrollChangeToIndex(index: Int) {
        self.segment.selectIndex(index)
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController == self {
            
            for subView:UIView in (self.navigationController?.navigationBar.subviews)!{
                if subView.isKindOfClass(NSClassFromString("_UINavigationBarBackground")!){
                 
                    subView.hidden = true
                    
//                    let viewBack = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 40))
//                     viewBack.backgroundColor = UIColor.blackColor()
//                     navigationController.navigationBar.addSubview(viewBack)
//                    navigationController.navigationBar.sendSubviewToBack(viewBack)
//                     viewBack.alpha = 0.6
                    
                }
            }
            
        }else {
            for view:UIView in (self.navigationController?.navigationBar.subviews)! {
                
                view.hidden = false
                
            }
        }
    }
//    
//    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 104, ScreeFrame.size.width, self.view.frame.size.height - 104) withArray:_controllsArray];
//    self.flipView.delegate = self;
//    [self.view addSubview:self.flipView];
//    }
//    #pragma mark -------- select Index
//    -(void)selectedIndex:(NSInteger)index
//    {
//    NSLog(@"%ld",index);
//    [self.flipView selectIndex:index];
//    
//    }
//    -(void)scrollChangeToIndex:(NSInteger)index
//    {
//    NSLog(@"%ld",index);
//    [self.segment selectIndex:index];
//    }
//
//    


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
