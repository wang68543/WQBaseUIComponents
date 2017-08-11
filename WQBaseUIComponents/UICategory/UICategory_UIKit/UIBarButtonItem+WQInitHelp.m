//
//  UIBarButtonItem+BarButtonHelp.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/29.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "UIBarButtonItem+WQInitHelp.h"

@implementation UIBarButtonItem (WQInitHelp)
+(instancetype)backBarButtonItemWithTarget:(id)target action:(SEL)action{
//    UIImage *image = [[UIImage imageNamed:@"register1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      //FIXME:这里需要根据自己的需要放返回箭头
    UIButton *btn = [self buttonWithImage:@"back" target:target action:action];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.frame = CGRectMake(0, 0, 80, 44);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
+(instancetype)presentBackItemWithTarget:(id)target action:(SEL)action{
    UIButton *btn = [self buttonWithImage:@"back" target:target action:action];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.frame = CGRectMake(0, 0, 80, 44);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
+(instancetype)itemWithImage:(NSString *)image target:(id)target action:(SEL)action{
    return [[UIBarButtonItem alloc] initWithCustomView:[self buttonWithImage:image target:target action:action]];
}
+(instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    return [[UIBarButtonItem alloc] initWithCustomView:[self buttonWithTitle:title target:target action:action]];
}

+(NSArray *)rightItemsWithImage:(NSString *)image target:(id)target action:(SEL)action{
    UIButton *btn = [self buttonWithImage:image target:target action:action];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -10;//此处修改到边界的距离，请自行测试
    return  @[negativeSeperator,btnItem];
}



+(UIButton *)buttonWithImage:(NSString *)imageName target:(id)target action:(SEL)action{
    return [self buttonWithTitle:nil image:imageName target:target action:action];
}
+(UIButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    return [self buttonWithTitle:title image:nil target:target action:action];
}
+(UIButton *)buttonWithTitle:(NSString *)title image:(NSString *)imageName  target:(id)target action:(SEL)action{
    UIButton *btn = [[UIButton alloc] init];
    if(imageName){
       [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if(title){
        [btn setTitle:title forState:UIControlStateNormal];
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    btn.adjustsImageWhenHighlighted = NO;
    [btn sizeToFit];
    return btn;
}
@end
