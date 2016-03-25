//
//  SDJustLoopView.m
//  de
//
//  Created by 张天琦 on 16/3/23.
//  Copyright © 2016年 C2H4. All rights reserved.
//

#import "SDJustLoopView.h"

@implementation SDJustLoopView

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    //    [[UIColor whiteColor] set];
    //    [SDColorMaker(178, 199, 194, 1) set];
    [SDColorMaker(_redNum, _greenNum, _blueNum, 1) set];
    //    [SDColorMaker(47, 47, 47, 1) set];    黑
    CGContextSetLineWidth(ctx, _lineWidth * SDProgressViewFontScale);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05; // 初始值0.05
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - SDProgressViewItemMargin;
    
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
    CGContextStrokePath(ctx);
    //    [SDColorMaker(47, 47, 47, 1) set];
    //    CGFloat maskW = (radius - 15) * 2.3;
    //    CGFloat maskH = maskW;
    //    CGFloat maskX = (rect.size.width - maskW) * 0.5;
    //    CGFloat maskY = (rect.size.height - maskH) * 0.5;
    //    CGContextAddEllipseInRect(ctx, CGRectMake(maskX, maskY, maskW, maskH));
    CGContextFillPath(ctx);
    
    // 进度数字
    NSString *progressStr = [NSString stringWithFormat:@"%.0f", self.progress * 100];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:30 * SDProgressViewFontScale];
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [self setCenterProgressText:progressStr withAttributes:attributes];
}
@end
