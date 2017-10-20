//
//  UIView+WQBasicAnimation.m
//  WQBaseUIDemo
//
//  Created by hejinyin on 2017/9/11.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import "UIView+WQBasicAnimation.h"
#import <objc/runtime.h>
@implementation UIView (WQBasicAnimation)


@dynamic running;
static char *const kLoadingKey = "running";
static NSString *const kRotation = @"WQRotationAnimation";

-(void)setRunning:(BOOL)running{
    objc_setAssociatedObject(self, &kLoadingKey, @(running), OBJC_ASSOCIATION_ASSIGN);
}
-(BOOL)isRunning{
    return [objc_getAssociatedObject(self, &kLoadingKey) boolValue];
}

- (void)startRotation{
    self.running = YES;
    CAAnimation *anmiation = [self.layer animationForKey:kRotation];
    if(!anmiation){
        //@"transform.rotation"也可以
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
-(void)stopRotation{
    if ([self.layer.animationKeys containsObject:kRotation]) {
         [self.layer removeAnimationForKey:kRotation];
    }
   
    self.running = NO;
}

//MARK: =========== 废弃的API ===========
-(void)startRotationImage{
    [self startRotation];
}
-(void)stopRotationImage{
    [self stopRotation];
}
@end
