//
//  WQUtils.h
//  WQBaseUIDemo
//
//  Created by WangQiang on 2017/6/3.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WQUtils : NSObject
/** 横线 */
+ (CALayer *)lineWithLength:(CGFloat)length atPoint:(CGPoint)point;
/** 竖线 */
+ (CALayer *)verticalLineHeight:(CGFloat)height atPoint:(CGPoint)point;
/** 给线条添加阴影 */
+ (void)layerAddLineShadow:(CALayer *)lineLayer;

/** 创建带阴影的线条 */
+ (CALayer *)shadowLineWithLength:(CGFloat)length atPoint:(CGPoint)point;

@end
