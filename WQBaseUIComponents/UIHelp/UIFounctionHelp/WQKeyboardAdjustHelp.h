//
//  WQKeyboardManager.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/2/28.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef UIView<UITextInput> WQTextFiledView;
typedef NS_ENUM(NSInteger,TextType) {
    TextTypeFiled,
    TextTypeView
};
@protocol WQKeyboardAdjustDelegate <NSObject>
@optional
-(void)keyboardAdjustShouldNext:(WQTextFiledView *)textFiledView textType:(TextType)textType content:(NSString *)content;
-(void)keyboardAdjustShouldDone:(WQTextFiledView *)textFiledView textType:(TextType)textType content:(NSString *)content;

@end

@interface WQKeyboardAdjustHelp : NSObject


/**
 初始化键盘弹出时页面的辅助工具(需要在界面所有的输入框都被加入到父View之后在初始化)点击此View会放弃键盘
 */
+(instancetype)keyboardAdjustHelpWithView:(UIView *)view excludeTag:(NSInteger)excludeTag;
/**
 点击背景放弃键盘,键盘弹出的时候自身上移

 @param moveView 键盘弹出时需要移动的View
 @param gestureView 点击时需要隐藏键盘的View
 @param excludeTag 当输入框的tag >= 此值的时候 不弹出键盘 为NSNotFound的时候 表示此界面没有不弹出键盘的输入款
 @return view需要Strong此工具
 */
+(instancetype)keyboardAdjustWithMoveView:(UIView *)moveView gestureRecognizerView:(UIView *)gestureView excludeTag:(NSInteger)excludeTag;
@property (weak ,nonatomic) id<WQKeyboardAdjustDelegate> delegate;
/** 键盘距离输入框的距离 */
@property(nonatomic, assign) CGFloat keyboardDistanceFromTextField;

/** To save keyboard animation duration. */
@property(nonatomic, assign) CGFloat    animationDuration;

/** To mimic the keyboard animation */
@property(nonatomic, assign) NSInteger  animationCurve;
@end
