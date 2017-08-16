//
//  WQKeyboardManager.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/2/28.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef UIView<UITextInput,UIContentSizeCategoryAdjusting,NSCoding> WQTextFiledView;
@interface  UIView(WQTextInput)
@property (copy ,nonatomic) NSString * wq_text;
/** 用于网络数据获取配置值 以及返回为字典 */
@property (copy ,nonatomic) NSString * dataKey;
@end

@protocol WQKeyboardAdjustDelegate <NSObject>
@optional

/**
 将要开始编辑下一个输入框 (textFiled的Return 和textView的'\n'都会触发)
 
 @param nextTextFiledView 即将开始输入的输入框
 @param preTextFiledView 当前正在输入的输入框
 @return 是否可以成为第一响应者
 */
-(BOOL)adjustShouldNext:(WQTextFiledView *)nextTextFiledView preTFView:(WQTextFiledView *)preTextFiledView;
/** 将要编辑某个输入框 */
-(BOOL)adjustShouldBeignEditing:(WQTextFiledView *)editTextFiledView;

-(void)adjustShouldDone:(WQTextFiledView *)textFiledView content:(NSString *)content;

/** 将要给某个输入框赋值 */
-(NSString *)shouldSetTFView:(WQTextFiledView *)tfView value:(NSString *)value;

/**
 最后的确定按钮是否能用 此处当当前所有输入框有变动的时候都会调此代理
 @return 是否可用
 */
-(BOOL)canEnableConfirmButtonInView;

@end

@interface WQKeyboardAdjustHelp : NSObject
/**
 初始化键盘弹出时页面的辅助工具(需要在界面所有的输入框都被加入到父View之后在初始化)点击此View会放弃键盘
 */
+(instancetype)keyboardAdjustHelpWithView:(UIView *)view;
/**
 点击背景放弃键盘,键盘弹出的时候自身上移

 @param moveView 键盘弹出时需要移动的View (响应此View上的输入框)
 @param gestureView 点击时需要隐藏键盘的View
 @return view需要Strong此工具
 */
+(instancetype)keyboardAdjustWithMoveView:(UIView *)moveView gestureRecognizerView:(UIView *)gestureView;
@property (weak ,nonatomic) id<WQKeyboardAdjustDelegate> delegate;
/** 当前页面的所有可编辑输入框 从上到下从左到右一次排列 */
@property (strong ,nonatomic ,readonly) NSArray <WQTextFiledView *> *textFieldViews;

/** 键盘距离输入框的距离 (默认10) */
@property(nonatomic, assign) CGFloat keyboardDistanceFromTextField;

/** To save keyboard animation duration. (default 0.25) */
@property(nonatomic, assign) CGFloat    animationDuration;

/** To mimic the keyboard animation */
@property(nonatomic, assign) NSInteger  animationCurve;

/** 按照顺序配置绑定的key */
- (void)configTFViewsKey:(NSArray *)dataKeys;

/** 获取当前代理里面所有输入框的值 (键值为绑定的key) */
-(NSDictionary *)allTFViewsValue;
/** 设置 输入框的值 按照绑定的键值 */
-(void)setAllTFViewsValueWithDic:(NSDictionary *)dic;
/** 设置 输入框的值 按坐标的排列顺序 */
-(void)setAllTFViewsValueWithArray:(NSArray *)values;
/** 设置 输入框的值 按按照模型来获取 */
-(void)setAllTFViewsValueWithModel:(id)instance;
/** 当所有输入框有文字的时候 才有效 */
@property (weak ,nonatomic) UIButton *lastConfirmButton;
/** 当前所有输入框是否有内容 */
- (BOOL)textFieldViewsHasText;

@end
