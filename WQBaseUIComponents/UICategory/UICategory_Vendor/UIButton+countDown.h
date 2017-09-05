//
//  UIButton+countDown.h
//  LiquoriceDoctorProject
//
//  Created by HenryCheng on 15/12/4.
//  Copyright © 2015年 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (countDown)
//TODO: --  如果出现界面闪烁的问题就把button类型改为Custom 默认的是System类型 
/** 倒计时timer */
@property (assign  ,nonatomic) dispatch_source_t waitTime;

/**
 *  倒计时按钮
 *
 *  @param timeLine 倒计时总时间
 *  @param title    还没倒计时的title
 *  @param subTitle 倒计时中的子名字，如时、分
 *  @param mColor   还没倒计时的颜色
 *  @param color    倒计时中的颜色
 */
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color;

/**
 倒计时

 @param timeOut 倒计时时间
 @param formatter 格式化显示
 @param color 倒计时时候的颜色 
 */
- (void)startWithTime:(NSUInteger)timeOut numberFormatter:(NSNumberFormatter *)formatter countColor:(UIColor *)color;
/** 停止倒计时*/
-(void)stopCountDown;

@end
