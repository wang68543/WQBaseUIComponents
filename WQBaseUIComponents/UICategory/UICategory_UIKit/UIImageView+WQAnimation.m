//
//  UIImageView+Animation.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/10.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "UIImageView+WQAnimation.h"
#import <objc/runtime.h>

@implementation UIImageView (WQAnimation)
@dynamic fadeImage;
@dynamic running;
//@synthesize running = _running;
static char *const kLoadingKey = "running";
static NSString *const kRotation = @"WQRotationAnimation";

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
-(void)startRotationImage{
    self.running = YES;
    CAAnimation *anmiation = [self.layer animationForKey:kRotation];
    if(!anmiation){
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
        rotationAnimation.duration = 1.0f;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = NSIntegerMax;
        rotationAnimation.removedOnCompletion = NO;
        anmiation = rotationAnimation;
    }
    [self.layer addAnimation:anmiation forKey:kRotation];
}
-(void)stopRotationImage{
    [self.layer removeAnimationForKey:kRotation];
    self.running = NO;
}
-(void)setRunning:(BOOL)running{
    objc_setAssociatedObject(self, &kLoadingKey, @(running), OBJC_ASSOCIATION_ASSIGN);
}
-(BOOL)isRunning{
    return [objc_getAssociatedObject(self, &kLoadingKey) boolValue];
}
@end
