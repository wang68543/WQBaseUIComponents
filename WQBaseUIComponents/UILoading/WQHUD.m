//
//  WQHUD.m
//  WQBaseUIDemo
//
//  Created by WangQiang on 2017/6/6.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import "WQHUD.h"
static CGFloat const kHUDShowTime = 2.0;
@implementation WQHUD
+ (UIView *)getTopView{
    __block UIWindow *view;
    NSArray *windows = [UIApplication sharedApplication].windows;
    [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.windowLevel < UIWindowLevelStatusBar){
            view = obj;
            *stop = YES;
        }
    }];
    if(!view) view = [UIApplication sharedApplication].keyWindow;
    return view;
}
+(WQHUD *)wq_showHUDAnimated:(BOOL)animated{
    return [self wq_showHUDAnimated:animated toView:nil];
}
+(WQHUD *)wq_showHUDAnimated:(BOOL)animated toView:(UIView *)view{
    if(!view){
        view = [self getTopView];
    }
    WQHUD *hud = [[self alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud showAnimated:animated];
    return hud;
}
+(WQHUD *)wq_showHUD:(NSString *)message toView:(UIView *)view{
    if(!view){
        view = [self getTopView];
    }
    WQHUD *hud = [WQHUD showHUDAddedTo:view animated:YES];
    if(message && message.length > 0)
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}
-(void)wq_hideHUD{
    [self wq_hideHUDAnimated:NO];
}
-(void)wq_hideHUDAnimated:(BOOL)animated{
    [self hideAnimated:animated];
}

+(void)wq_showTipError:(NSError *)error{
    [self wq_showTipError:error toView:nil];
}
+(void)wq_showTipError:(NSError *)error toView:(UIView *)view{
    [self wq_showTipMessage:[self errorDescription:error] toView:view];
}
+(void)wq_showTipMessage:(NSString *)message{
    [self wq_showTipMessage:message toView:nil];
}
+(void)wq_showTipMessage:(NSString *)message toView:(UIView *)view{
    if(!view){
        view = [self getTopView];
    }
    WQHUD *hud = [[WQHUD alloc] initWithView:view];
    [view addSubview:hud];
    UILabel *tipLabel = [[UILabel alloc] init] ;
    tipLabel.text = message;
    tipLabel.numberOfLines = 0;
    tipLabel.font = [UIFont systemFontOfSize:15.0];
    tipLabel.backgroundColor = [UIColor blackColor];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 60, MAXFLOAT);
    [tipLabel sizeToFit];
    tipLabel.frame = CGRectMake(0, 0, CGRectGetWidth(tipLabel.frame), CGRectGetHeight(tipLabel.frame));
    hud.customView = tipLabel;
    hud.margin = 10.0;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView.backgroundColor = hud.backgroundColor;
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    [hud hideAnimated:YES afterDelay:kHUDShowTime];
}

+ (void)wq_showSuccess:(NSString *)success{
    [self wq_showSuccess:success toView:nil];
}
+ (void)wq_showError:(NSString *)error{
    [self wq_showError:error toView:nil];
}
+ (void)wq_showSuccess:(NSString *)success toView:(UIView *)view{
    [self wq_show:success icon:@"success.png" view:view];
}
+ (void)wq_showError:(NSString *)error toView:(UIView *)view{
    [self wq_show:error icon:@"error.png" view:view];
}
+ (void)wq_show:(NSString *)text icon:(NSString *)icon view:(UIView *)view{
    if (view == nil) view = [self getTopView];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:kHUDShowTime];
}

//TODO: 错误信息描述
+(NSString *)errorDescription:(NSError *)error{
    if ([error code] == -1009) {
        return @"您的网络有问题,\n请查看网络设置";
        
    } else if ([error code] == -1004) {
        return @"不能连接到服务器,\n请查看网络设置";
        
    }  else if ([error code] == -1001) {
        return @"请求超时";
    }
//    else if ([error code] == noDataErrorCode){
//        return [NSString stringWithFormat:@"%@", [error localizedDescription]];
//    }
    else{
         return [NSString stringWithFormat:@"%@", [error localizedDescription]];
//        return [NSString stringWithFormat:@"%@:\n%@",NSLocalizedString(@"错误", nil), [error localizedDescription]];
    }
}
@end
