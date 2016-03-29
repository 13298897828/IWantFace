//
//  RecordViewController.swift
//  IWantFace
//
//  Created by 张天琦 on 16/3/23.
//  Copyright © 2016年 C2H4. All rights reserved.
//

import UIKit

private let reuseIdentifier = "timeCell"
private let reuseDateIdentifier = "dateCell"
class RecordViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    let Width = UIScreen.mainScreen().bounds.size.width
    var cellWitdh = CGFloat()
    @IBOutlet weak var bigLoop: SDJustLoopView!
    @IBOutlet weak var middleLoop: SDJustLoopView!
    @IBOutlet weak var smallLoop: SDJustLoopView!
    

 
//  dateCollectionView
    @IBOutlet weak var dateTableView: UITableView!
//  timeCollcetionView
    @IBOutlet weak var timeTableView: UITableView!

    @IBOutlet weak var containBG: UIView!
    
    @IBOutlet weak var buttomLine: UIView!
    @IBOutlet weak var buttomImg: UIImageView!
    @IBOutlet weak var buttomBackImgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addLoop()

        timeTableView.registerNib(UINib.init(nibName: "TimeTableViewCell", bundle: nil), forCellReuseIdentifier: "timeCell")
        timeTableView.tag = 100
        dateTableView.registerNib(UINib.init(nibName: "DateTableViewCell", bundle: nil), forCellReuseIdentifier: "dateCell")
        dateTableView.tag = 200
        timeTableView.separatorColor = UIColor.clearColor()
        timeTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        dateTableView.separatorColor = UIColor.clearColor()
        dateTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        timeTableView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI) / 2)
        dateTableView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI) / 2)
        timeTableView.allowsSelection = false
        dateTableView.allowsSelection = false
     
    }
// MARK: - 添加三个环
    func addLoop()  {
        bigLoop.redNum = 254
        bigLoop.greenNum = 220
        bigLoop.blueNum = 98
        bigLoop.lineWidth = 3.5
        bigLoop.progress = 0.5
        
        middleLoop.redNum = 0
        middleLoop.greenNum = 0
        middleLoop.blueNum = 0
        middleLoop.lineWidth = 3.8
        middleLoop.progress = 0.7
        
        smallLoop.redNum = 22
        smallLoop.greenNum = 165
        smallLoop.blueNum = 175
        smallLoop.lineWidth = 4.1
        smallLoop.progress = 0.9
         

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.tag == 100 {
            timeTableView.selectRowAtIndexPath(NSIndexPath(forRow: Int(timeTableView.contentOffset.y / 60),inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Top)
            tableView(timeTableView, didSelectRowAtIndexPath: NSIndexPath(forRow: Int(timeTableView.contentOffset.y / 60),inSection: 0))
            print(Int(timeTableView.contentOffset.y / 60))
            
        }
        
        if scrollView.tag == 200{
        dateTableView.selectRowAtIndexPath(NSIndexPath(forRow:Int(dateTableView.contentOffset.y /  UIScreen.mainScreen().bounds.size.width * 5.96 + 3) , inSection: 0), animated: true,scrollPosition: UITableViewScrollPosition.Middle)
        tableView(dateTableView, didSelectRowAtIndexPath: NSIndexPath(forRow:Int(dateTableView.contentOffset.y /  UIScreen.mainScreen().bounds.size.width * 5.96 + 3) , inSection: 0))
 
 
          let index1 = NSIndexPath(forRow:Int(dateTableView.contentOffset.y /  UIScreen.mainScreen().bounds.size.width * 5.96 + 4) , inSection: 0)
            let cell = dateTableView.cellForRowAtIndexPath(index1) as! DateTableViewCell
            cell.selected = false
            cell.buttonImgView.image = UIImage(named: "circle-gray")
            let index2 = NSIndexPath(forRow:Int(dateTableView.contentOffset.y /  UIScreen.mainScreen().bounds.size.width * 5.96 + 2) , inSection: 0)
            let cell1 = dateTableView.cellForRowAtIndexPath(index2) as! DateTableViewCell
            cell1.selected = false
            cell1.buttonImgView.image = UIImage(named: "circle-gray")
            }
        
    }
    override func viewDidAppear(animated: Bool) {
//        if UIScreen.mainScreen().bounds.size.width == 414 {
//         UIView.transitionWithView(self.dateCollectionView, duration: 0.01, options: UIViewAnimationOptions.TransitionNone, animations: {
//                self.dateCollectionView.frame.origin.y += 20
//                self.buttomImg.frame.origin.y += 40
//                self.buttomLine.frame.size.height += 20
//                self.buttomLine.frame.origin.y += 20
//            }, completion: { (Bool) in
//         })
//        }
//    }
    }
}
extension RecordViewController {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 21
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.tag == 100 {
            let cell = tableView.dequeueReusableCellWithIdentifier("timeCell", forIndexPath: indexPath) as! TimeTableViewCell
            cell.contentView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) / 2)
//            cell.timeLabel.text = "lalalla"
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("dateCell", forIndexPath: indexPath)  
        cell.contentView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) / 2)
        cell.backgroundColor = UIColor.clearColor()
        return cell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.tag == 200{
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! DateTableViewCell
            cell.buttonImgView.image = UIImage(named: "circle-orange")
            cell.selectedBackgroundView = {
            return UIView()
            }()
        }
        
   
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       
        if tableView.tag == 200 {
            return UIScreen.mainScreen().bounds.size.width / 6
            
        }
         return 80
    }
}