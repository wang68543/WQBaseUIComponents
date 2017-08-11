//
//  WQBaseCommonItem.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/13.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^CommonOperation)();

typedef NS_ENUM(NSInteger ,CommonItemType) {
    CommonItemTypeBase,
    CommonItemTypeArrow,
    CommonItemTypeSwitch,
    CommonItemTypeSubtitle,
    CommonItemTypeCenter,
    CommonItemTypeCustom,//自定义Cell
};
@interface WQCommonBaseItem : NSObject

+(instancetype)baseItemWithTitle:(NSString *)title;
+(instancetype)baseItemWithIcon:(NSString *)icon title:(NSString *)title;
- (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title;

-(void)commonInit;

@property (assign ,nonatomic) CGSize iconSize;

@property (assign ,nonatomic,readonly) CommonItemType itemType;
@property (copy ,nonatomic) NSString *icon;
@property (copy ,nonatomic) NSString *title;

@property (copy ,nonatomic) CommonOperation operation;


/** 标题字体 */
@property (strong ,nonatomic) UIFont *titleFont;

/**
 cell的背景颜色
 */
@property (strong ,nonatomic) UIColor *backgroundColor;
/** 设置Cell选中的背景颜色 */
@property (strong ,nonatomic) UIColor *selectBackgroundColor;

/**
 文字颜色
 */
@property (strong ,nonatomic) UIColor *titleColor;

/** 如果这里值小于0 就使用Group的值 */
@property (assign ,nonatomic) CGFloat cellHeight;
@end
