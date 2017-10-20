//
//  UIImageView+Animation.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/10.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WQAnimation)
/**
 此属性只具备设置不具备读取
 */
@property (strong ,nonatomic) UIImage *fadeImage;

///**
// 旋转图片
// */
//-(void)startRotationImage;
//-(void)stopRotationImage;
//@property (assign ,nonatomic,readonly,getter=isRunning) BOOL running;

@end
