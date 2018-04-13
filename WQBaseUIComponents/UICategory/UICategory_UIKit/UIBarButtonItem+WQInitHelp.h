//
//  UIBarButtonItem+BarButtonHelp.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/29.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WQInitHelp)
+(instancetype)backBarButtonItemWithTarget:(id)target action:(SEL)action;
+(instancetype)presentBackItemWithTarget:(id)target action:(SEL)action;

+(instancetype)itemWithImage:(NSString *)image target:(id)target action:(SEL)action;
+(instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
/**
 *  返回需要靠右的按钮
 */
+(NSArray *)rightItemsWithImage:(NSString *)image target:(id)target action:(SEL)action;
@end
