//
//  NoneToDoubleCollectionCell.m
//  RMCalendar
//
//  Created by 张天琦 on 16/3/2.
//  Copyright © 2016年 迟浩东. All rights reserved.
//

#import "NoneToDoubleCollectionCell.h"
#import "UIView+CustomFrame.h"
#import "RMCalendarModel.h"
#import "PictureModel.h"
//#import "WantFace-Swift.h"
#define kFont(x) [UIFont systemFontOfSize:x]
#define COLOR_HIGHLIGHT ([UIColor redColor])
#define COLOR_NOAML ([UIColor colorWithRed:26/256.0  green:168/256.0 blue:186/256.0 alpha:1])
@interface NoneToDoubleCollectionCell()

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImgLabel;
@property (weak, nonatomic) IBOutlet UIImageView *secondImgLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImgLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cornerImgView;

@end
@implementation NoneToDoubleCollectionCell




- (void)setModel:(RMCalendarModel *)model {
    _model = model;
    
    if (model.picModel.picArray.count == 0) {
        self.backgroundColor = [UIColor whiteColor];
        
    }else if(model.picModel.picArray.count == 1){
//        这还缺个角和背景颜色
        NSString * picName0 = [NSString stringWithFormat:@"%@",model.picModel.picArray[0]];
        
        self.firstImgLabel.image = [UIImage imageNamed:picName0];
//        [self.firstImgLabel kt_addCornerWithRadius:self.firstImgLabel.frame.size.width / 2];
        
    }else {
        
        NSString * picName0 = [NSString stringWithFormat:@"%@",model.picModel.picArray[0]];
        NSString * picName1 = [NSString stringWithFormat:@"%@",model.picModel.picArray[1]];
        
        self.firstImgLabel.image = [UIImage imageNamed:picName0];
        self.secondImgLabel.image = [UIImage imageNamed:picName1];
//        [self.firstImgLabel kt_addCornerWithRadius:self.firstImgLabel.frame.size.width / 2];
//        [self.secondImgLabel kt_addCornerWithRadius:self.firstImgLabel.frame.size.width / 2];
    }
  
    switch (model.style) {
        case CellDayTypeEmpty:
            self.backImgLabel.hidden = YES;
            self.dayLabel.hidden = YES;
            self.backgroundColor = [UIColor whiteColor];
            break;

            
        case CellDayTypeClick:
            self.dayLabel.hidden = NO;
            self.backImgLabel.hidden = NO;
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarNormalDate"]];
            self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            self.dayLabel.textColor = [UIColor whiteColor];
             break;
        default:
            self.dayLabel.hidden = NO;
            self.backImgLabel.hidden = YES;
 
            self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];

            self.dayLabel.textColor = [UIColor lightGrayColor];
//            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarDisableDate"]];
            self.backgroundColor = [UIColor whiteColor];
            break;

    }
    
   
}

- (void)awakeFromNib {
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarSelectedDate"]];
    
    
    self.dayLabel.font = kFont(12);
    // Initialization code
}

@end
