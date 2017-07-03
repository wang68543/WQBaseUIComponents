//
//  WQRadioGroup.h
//  WQBaseUIDemo
//
//  Created by WangQiang on 2017/6/12.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIButton(WQRadioButton)
+(instancetype)radioTitle:(NSString *)title selectedTitle:(NSString *)selTitle titleColor:(UIColor *)titleColor selectedTitleColor:(UIColor *)selColor image:(NSString *)imageName selectedImage:(NSString *)selImageName;
@end
@interface WQRadioGroup : UIView

/** 只支持单选 */
+ (instancetype)radioGroupWithButtons:(NSArray<UIButton *> *)btns;
/** 是否是必须有一个是选中的 默认为Yes */
@property (assign ,nonatomic) BOOL mustSelection;
@property (strong ,nonatomic,readonly) NSArray<UIButton *> *buttons;
/** 对应buttons里面的button排序 (从0开始) NSNotFound为当前没有选中项 */
@property (assign ,nonatomic) NSUInteger selectedIndex;
@end
