//
//  PictureModel.h
//  RMCalendar
//
//  Created by 张天琦 on 16/3/2.
//  Copyright © 2016年 迟浩东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureModel : NSObject
/**
 *  年
 */
@property (nonatomic, assign) NSInteger year;
/**
 *  月
 */
@property (nonatomic, assign) NSInteger month;
/**
 *  日
 */
@property (nonatomic, assign) NSInteger day;

/**
 *  单价
 */
@property (nonatomic, strong) NSMutableArray *picArray;

@end
