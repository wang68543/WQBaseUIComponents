//
//  WQStepNumberView.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/5/8.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQStepNumberView;
@protocol WQStepNumberDelegate <NSObject>
- (void)stepNumberView:(WQStepNumberView *)stepNumber didChange:(CGFloat)numberValue;
@end

@interface WQStepNumberView : UIView
@property (strong ,nonatomic,readonly) UIButton *addButton;
@property (strong ,nonatomic,readonly) UIButton *subtractButton;
@property (strong ,nonatomic,readonly) UITextField *countNumTextField;
@property (weak ,nonatomic) id<WQStepNumberDelegate> delegate;
/** 步进的值是否支持小数 */
@property (assign ,nonatomic) BOOL isStepFloat;

@property (assign ,nonatomic) CGFloat numberValue;
@property (assign ,nonatomic) CGFloat minValue;
@property (assign ,nonatomic) CGFloat stepValue;
@end
