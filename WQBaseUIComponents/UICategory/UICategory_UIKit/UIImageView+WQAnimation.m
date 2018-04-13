//
//  UIImageView+Animation.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/10.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "UIImageView+WQAnimation.h"
@implementation UIImageView (WQAnimation)
@dynamic fadeImage;


-(void)setFadeImage:(UIImage *)fadeImage{
    CATransition *transtion = [CATransition animation];
    transtion.duration = 0.5;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transtion setType:kCATransitionFade];
//        [transtion setSubtype:kCATransitionFromTop];
    [self.layer addAnimation:transtion forKey:kCATransitionFade];
    self.image = fadeImage;
}
-(UIImage *)fadeImage{
    NSAssert(NO, @"fadeImage只能设置不能读");
    return nil;
}
@end
