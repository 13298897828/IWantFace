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
class RecordViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    let Width = UIScreen.mainScreen().bounds.size.width
    var cellWitdh = CGFloat()
    @IBOutlet weak var bigLoop: SDJustLoopView!
    @IBOutlet weak var middleLoop: SDJustLoopView!
    @IBOutlet weak var smallLoop: SDJustLoopView!
    
//  timeCollcetionView
    @IBOutlet weak var timeCollectionView: UICollectionView!
//  dateCollectionView
    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var buttomLine: UIView!
    @IBOutlet weak var buttomImg: UIImageView!
    @IBOutlet weak var buttomBackImgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addLoop()
        self.timeCollectionView.registerNib(UINib.init(nibName: "TimeViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.timeCollectionView.tag = 100
        self.dateCollectionView.registerNib(UINib.init(nibName: "DateViewCell", bundle: nil), forCellWithReuseIdentifier: reuseDateIdentifier)
        self.dateCollectionView.tag = 200
        dateCollectionView.allowsSelection = false
        dateCollectionView.allowsMultipleSelection = false

     
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
    override func viewDidAppear(animated: Bool) {
        if UIScreen.mainScreen().bounds.size.width == 414 {
         UIView.transitionWithView(self.dateCollectionView, duration: 0.01, options: UIViewAnimationOptions.TransitionNone, animations: {
                self.dateCollectionView.frame.origin.y += 20
                self.buttomImg.frame.origin.y += 40
                self.buttomLine.frame.size.height += 20
                self.buttomLine.frame.origin.y += 20
            }, completion: { (Bool) in
         })
        }
    }
}
extension RecordViewController {
    
// MARK: - 添加时间collectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if  collectionView.tag == 100 {
            
              return 15
        }else {
            
            return 19
        }
       
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 100 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
           
           
            return cell
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseDateIdentifier, forIndexPath: indexPath) as! DateViewCell
      
            cellWitdh = cell.frame.size.width
    
        return cell
       
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView.tag == 200{
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! DateViewCell
            cell.imgView.image = UIImage(named: "circle-orange")
        }else if collectionView.tag == 100{
            
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let index = NSIndexPath(forItem:Int(dateCollectionView.contentOffset.x / cellWitdh + 3), inSection: 0)
        collectionView(dateCollectionView, didSelectItemAtIndexPath: index)
        self.dateCollectionView.selectItemAtIndexPath(index, animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
        let index1 = NSIndexPath(forItem:Int(dateCollectionView.contentOffset.x / cellWitdh + 4), inSection: 0)
        let cell = dateCollectionView.cellForItemAtIndexPath(index1) as! DateViewCell
        cell.selected = false
        cell.imgView.image = UIImage(named: "circle-gray")
        let index2 = NSIndexPath(forItem:Int(dateCollectionView.contentOffset.x / cellWitdh + 2), inSection: 0)
        let cell1 = dateCollectionView.cellForItemAtIndexPath(index2) as! DateViewCell
        cell1.imgView.image = UIImage(named: "circle-gray")
        cell1.selected = false
    }
    

}
