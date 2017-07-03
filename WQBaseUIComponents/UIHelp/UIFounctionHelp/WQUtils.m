//
//  WQUtils.m
//  WQBaseUIDemo
//
//  Created by WangQiang on 2017/6/3.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import "WQUtils.h"

@implementation WQUtils
//TODO: 横线
+ (CALayer *)lineWithLength:(CGFloat)length atPoint:(CGPoint)point {
    CALayer *line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor;
    line.frame = CGRectMake(point.x, point.y, length, 1/[UIScreen mainScreen].scale);
    
    return line;
}
//TODO: 竖线
+ (CALayer *)verticalLineHeight:(CGFloat)height atPoint:(CGPoint)point{
    CALayer *line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor;
    line.frame = CGRectMake(point.x, point.y, 1/[UIScreen mainScreen].scale,height);
    return line;
}
+ (void)layerAddLineShadow:(CALayer *)lineLayer{
    lineLayer.shadowOffset = CGSizeMake(0.0, 0.5);
    lineLayer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    lineLayer.shadowOpacity = 0.2;
}
+(CALayer *)shadowLineWithLength:(CGFloat)length atPoint:(CGPoint)point{
    CALayer *line = [self lineWithLength:length atPoint:point];
    [self layerAddLineShadow:line];
    return line;
}
@end
