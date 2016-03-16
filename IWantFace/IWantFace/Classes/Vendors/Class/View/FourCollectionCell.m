//
//  FourCollectionCell.m
//  RMCalendar
//
//  Created by 张天琦 on 16/3/2.
//  Copyright © 2016年 迟浩东. All rights reserved.
//

#import "FourCollectionCell.h"
#import "NoneToDoubleCollectionCell.h"
#import "UIView+CustomFrame.h"
#import "RMCalendarModel.h"
#import "PictureModel.h"
//#import "WantFace-Swift.h"

#define kFont(x) [UIFont systemFontOfSize:x]
#define COLOR_HIGHLIGHT ([UIColor redColor])
#define COLOR_NOAML ([UIColor colorWithRed:26/256.0  green:168/256.0 blue:186/256.0 alpha:1])
@interface FourCollectionCell()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImgView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImgView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImgView;
@property (weak, nonatomic) IBOutlet UIImageView *fouthImgView;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UIView *imgBackView1;
@property (weak, nonatomic) IBOutlet UIView *imgBackView2;
@property (weak, nonatomic) IBOutlet UIImageView *cornerImgView;


@end
@implementation FourCollectionCell
- (void)setModel:(RMCalendarModel *)model {
    _model = model;
    self.imgBackView1.backgroundColor = [UIColor clearColor];
    self.imgBackView2.backgroundColor =[UIColor clearColor];
    if (model.picModel.picArray.count == 3) {
        NSString * picName0 = [NSString stringWithFormat:@"%@",model.picModel.picArray[0]];
        NSString * picName1 = [NSString stringWithFormat:@"%@",model.picModel.picArray[1]];
        NSString * picName2 = [NSString stringWithFormat:@"%@",model.picModel.picArray[2]];
        self.firstImgView.image = [UIImage imageNamed:picName0];
        self.secondImgView.image = [UIImage imageNamed:picName1];
        self.thirdImgView.image = [UIImage imageNamed:picName2];
    }else {
  
    NSString * picName0 = [NSString stringWithFormat:@"%@",model.picModel.picArray[0]];
    NSString * picName1 = [NSString stringWithFormat:@"%@",model.picModel.picArray[1]];
    NSString * picName2 = [NSString stringWithFormat:@"%@",model.picModel.picArray[2]];
    NSString * picName3 = [NSString stringWithFormat:@"%@",model.picModel.picArray[3]];
    self.firstImgView.image = [UIImage imageNamed:picName0];
    self.secondImgView.image = [UIImage imageNamed:picName1];
    self.thirdImgView.image = [UIImage imageNamed:picName2];
    self.fouthImgView.image = [UIImage imageNamed:picName3];
    }
//    [self.firstImgView kt_addCornerWithRadius:self.firstImgView.frame.size.width / 2];
//    [self.secondImgView kt_addCornerWithRadius:self.firstImgView.frame.size.width / 2];
//    [self.thirdImgView kt_addCornerWithRadius:self.firstImgView.frame.size.width / 2];
//    [self.fouthImgView kt_addCornerWithRadius:self.firstImgView.frame.size.width / 2];

    switch (model.style) {
        case CellDayTypeEmpty:
            self.backImgView.hidden = YES;
            self.dayLabel.hidden = YES;
            self.backgroundColor = [UIColor whiteColor];
            break;
            
            
        case CellDayTypeClick:
            self.dayLabel.hidden = NO;
            self.backImgView.hidden = NO;
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarNormalDate"]];
            self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            self.dayLabel.textColor = [UIColor whiteColor];
            break;
            
        default:
            self.dayLabel.hidden = NO;
            self.backImgView.hidden = YES;
            
            self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            
            self.dayLabel.textColor = [UIColor lightGrayColor];
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarDisableDate"]];
            break;
            
    }
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

@end
