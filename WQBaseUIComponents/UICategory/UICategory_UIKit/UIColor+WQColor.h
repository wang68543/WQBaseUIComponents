//
//  UIColor+WQColor.h
//  WQBaseDemo
//
//  Created by WangQiang on 2017/5/24.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Colours.h"
@interface UIColor (WQColor)
+(instancetype)randomColor;
/** 主题颜色 主要是navBar的颜色 */
+(instancetype)themeColor;
/** 导航栏上标题的颜色 */
+(instancetype)navBarTitleColor;
/** 导航栏上Item标题的颜色 */
+(instancetype)navBarItemTitleColor;
/** 通用控制器 颜色背景 */
+(instancetype)viewControllerNormalBackgroundColor;
/** 控制器 灰色背景 */
+(instancetype)viewControllerGrayBackgroundColor;
/** 分割线颜色 */
+(instancetype)separatorLineColor;

+(instancetype)textTitle1;
+(instancetype)textTitle2;
+(instancetype)textTitle3;
+(instancetype)textTitle4;
@end
