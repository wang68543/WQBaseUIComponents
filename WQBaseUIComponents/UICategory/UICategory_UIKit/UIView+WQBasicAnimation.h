//
//  UIView+WQBasicAnimation.h
//  WQBaseUIDemo
//
//  Created by hejinyin on 2017/9/11.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WQBasicAnimation)
/**  控件旋转 */
- (void)startRotation;
- (void)stopRotation;



-(void)startRotationImage __deprecated_msg("请使用 startRotation");
-(void)stopRotationImage __deprecated_msg("请使用 stopRotation");


@property (assign ,nonatomic,readonly,getter=isRunning) BOOL running;
@end
