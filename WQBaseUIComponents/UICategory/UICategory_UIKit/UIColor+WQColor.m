//
//  UIColor+WQColor.m
//  WQBaseDemo
//
//  Created by WangQiang on 2017/5/24.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import "UIColor+WQColor.h"

@implementation UIColor (WQColor)
+(instancetype)randomColor{
    return [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
}
//MARK: 主题颜色 主要是navBar的颜色
+(instancetype)themeColor{
    //#2FC0BB
    return [UIColor colorWithR:47 G:192 B:187];
}
//MARK: 导航栏上标题的颜色
+(instancetype)navBarTitleColor{
    return [UIColor whiteColor];
}
//MARK: 导航栏上Item标题的颜色
+(instancetype)navBarItemTitleColor{
    return [UIColor whiteColor];
}
//MARK: 通用控制器 颜色背景
+(instancetype)viewControllerNormalBackgroundColor{
    return [UIColor colorFromHexString:@"F5F5F5"] ;
}
//MARK: 控制器 灰色背景
+(instancetype)viewControllerGrayBackgroundColor{
    return [[UIColor grayColor] colorWithAlphaComponent:0.8];
}
//MARK: 分割线颜色
+(instancetype)separatorLineColor{
    return [UIColor colorWithR:238 G:238 B:238];
}
//MARK: 边框线条的颜色
+(instancetype)lineBorderColor{
    return [UIColor colorWithR:221 G:221 B:221];
}
//MARK: 按钮失效的时候的颜色
+(instancetype)disableButtonColor{
    return [[self themeColor] colorWithAlphaComponent:0.6];
}
+(instancetype)textTitle1{
    return [UIColor colorWithR:12 G:12 B:13];
}
+(instancetype)textTitle2{
    return [UIColor colorWithR:86 G:86 B:89];
}
+(instancetype)textTitle3{
     return [UIColor colorWithR:157 G:160 B:166];
}
+(instancetype)textTitle4{
    return [UIColor colorWithR:195 G:197 B:204];
}
@end
