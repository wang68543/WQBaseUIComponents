//
//  UIView+WQFrame.h
//  WQBaseDemo
//
//  Created by WangQiang on 2017/5/26.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WQLayout)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

- (void)addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii;
- (void)addCornerRadius:(CGFloat)radius;
- (UIImage *)snapshot;
@end
