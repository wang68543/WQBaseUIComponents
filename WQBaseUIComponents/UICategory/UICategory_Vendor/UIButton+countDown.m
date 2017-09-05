//
//  UIButton+countDown.m
//  LiquoriceDoctorProject
//
//  Created by HenryCheng on 15/12/4.
//  Copyright © 2015年 iMac. All rights reserved.
//

#import "UIButton+countDown.h"

#import <objc/runtime.h>

@implementation UIButton (countDown)
static const char * kWaitTime = "waitTime";
-(void)setWaitTime:(dispatch_source_t)waitTime{
    objc_setAssociatedObject(self, kWaitTime, waitTime, OBJC_ASSOCIATION_ASSIGN);
}
-(dispatch_source_t)waitTime{
    return objc_getAssociatedObject(self, kWaitTime);
}


-(void)startWithTime:(NSUInteger)timeOut numberFormatter:(NSNumberFormatter *)formatter countColor:(UIColor *)color{
    NSAttributedString *currentAttibutedString = [self currentAttributedTitle];
    UIControlState currentState = UIControlStateNormal;
    
    NSString *currentText;
    UIColor *currentColor;

    if (!currentAttibutedString) {
        currentText = [self currentTitle];
        currentColor = [self currentTitleColor];
    }else{
        [self setAttributedTitle:nil forState:currentState];
    }
    self.enabled = NO;
    
    __weak typeof(self) weakSelf = self;
    //倒计时时间
    __block NSInteger timeLine = timeOut;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //每隔多长时间执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    self.waitTime = _timer;

    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeLine <= 0) {
            dispatch_source_cancel(_timer);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
        
                [weakSelf setTitle:[formatter stringFromNumber:@(timeLine)] forState:currentState];
            });
            timeLine --;
        }
    });
    //设置倒计时文字的颜色
    [self setTitleColor:color forState:currentState];
    
    //取消倒计时回调
    dispatch_source_set_cancel_handler(_timer, ^{

        dispatch_async(dispatch_get_main_queue(), ^{
            if (currentAttibutedString) {
                [weakSelf setAttributedTitle:currentAttibutedString forState:currentState];
            }else{
                [weakSelf setTitle:currentText forState:currentState];
                [weakSelf setTitleColor:currentColor forState:currentState];
            }
            weakSelf.enabled = YES;
        });

    });
    dispatch_resume(_timer);
}
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color {

    self.enabled = NO;
   
    __weak typeof(self) weakSelf = self;
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
     [self setTitleColor:color forState:UIControlStateNormal];
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setTitle:title forState:UIControlStateNormal];
                [weakSelf setTitleColor:mColor forState:UIControlStateNormal];
                weakSelf.enabled = YES;
            });
        } else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%02d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *leftTime = [NSString stringWithFormat:@"%@%@s",subTitle,timeStr];
                [weakSelf setTitle:leftTime forState:UIControlStateNormal];
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}
-(void)stopCountDown{
    if (self.waitTime) {
        dispatch_source_cancel(self.waitTime);
        self.waitTime = nil;
    }
    self.enabled = YES;
}
@end
