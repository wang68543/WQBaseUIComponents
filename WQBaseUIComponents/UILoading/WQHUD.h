//
//  WQHUD.h
//  WQBaseUIDemo
//
//  Created by WangQiang on 2017/6/6.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface WQHUD : MBProgressHUD
+(NSString *)errorDescription:(NSError *)error;


+(WQHUD *)wq_showHUDAnimated:(BOOL)animated;
+(WQHUD *)wq_showHUDAnimated:(BOOL)animated toView:(UIView *)view;
+(WQHUD *)wq_showHUD:(NSString *)message toView:(UIView *)view;
/** 隐藏 没有动画 */
-(void)wq_hideHUD;
-(void)wq_hideHUDAnimated:(BOOL)animated;

+(void)wq_showTipError:(NSError *)error;
+(void)wq_showTipError:(NSError *)error toView:(UIView *)view;
+(void)wq_showTipMessage:(NSString *)message;
+(void)wq_showTipMessage:(NSString *)message toView:(UIView *)view;

+ (void)wq_showSuccess:(NSString *)success;
+ (void)wq_showError:(NSString *)error;
+ (void)wq_showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)wq_showError:(NSString *)error toView:(UIView *)view;
+ (void)wq_show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;

@end
