//
//  CustomView.m
//  UIViewDemo
//
//  Created by 讯心科技 on 2017/11/28.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 0, 0);
    
    CGContextAddLineToPoint(context, rect.size.width - 30.0, 0.0);// 上平行线
    
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height); // 斜线
    
    CGContextAddLineToPoint(context, 0, rect.size.height);// 下平行线
    
    CGContextClosePath(context);
    
    [[UIColor orangeColor] setFill];
    
    CGContextDrawPath(context, kCGPathFill);
}


@end
