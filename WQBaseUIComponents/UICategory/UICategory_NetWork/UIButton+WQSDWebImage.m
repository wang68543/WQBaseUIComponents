//
//  UIButton+WQSDWebImage.m
//  WQBaseDemo
//
//  Created by WangQiang on 2017/7/5.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import "UIButton+WQSDWebImage.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation UIButton (WQSDWebImage)
-(void)wq_btnDownloadImage:(NSString *)btnImage forState:(UIControlState)state placeholder:(NSString *)place{
    [self sd_setImageWithURL:[NSURL URLWithString:btnImage] forState:state placeholderImage:[UIImage imageNamed:place]];
}
-(void)wq_btnDownloadBackImage:(NSString *)btnBackImage forState:(UIControlState)state placeholder:(NSString *)place{
    [self sd_setBackgroundImageWithURL:[NSURL URLWithString:btnBackImage] forState:state placeholderImage:[UIImage imageNamed:place]];
}
@end
