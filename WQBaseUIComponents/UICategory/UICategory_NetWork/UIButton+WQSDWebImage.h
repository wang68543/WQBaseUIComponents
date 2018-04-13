//
//  UIButton+WQSDWebImage.h
//  WQBaseDemo
//
//  Created by WangQiang on 2017/7/5.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WQSDWebImage)
-(void)wq_btnDownloadImage:(NSString *)btnImage forState:(UIControlState)state placeholder:(NSString *)place;
-(void)wq_btnDownloadBackImage:(NSString *)btnBackImage forState:(UIControlState)state placeholder:(NSString *)place;
@end
