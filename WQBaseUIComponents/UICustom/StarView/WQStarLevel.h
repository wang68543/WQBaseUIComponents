//
//  StarLevel.h
//  YunShouHu
//
//  Created by WangQiang on 2016/10/12.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , DrawType) {
    DrawTypeStar,
    DrawTypeImage,
};

@interface WQStarLevel : UIControl
@property (assign ,nonatomic) DrawType drawType;
/**
 星星的高度(星星的高度与宽度需相等)
 */
@property (assign ,nonatomic) CGFloat starHeight;
/** 第一颗星距离左边的距离 */
@property (assign ,nonatomic) CGFloat leftPadding;
@property (assign ,nonatomic) CGFloat starValue;

//TODO:=====画图片的
@property (strong ,nonatomic) UIImage *normalImage;
@property (strong ,nonatomic) UIImage *highlightImage;
//TODO:=====画星星的属性设置
/**
 是否支持显示半颗星
 */
@property (assign ,nonatomic ,getter=isHalf) BOOL half;


/**
 隐藏未点亮的星星(此时只做显示不做交互)
 */
@property (assign ,nonatomic) BOOL hideUnHighlited;

/**
 星星高亮的颜色
 */
@property (strong ,nonatomic) UIColor *starHighlightedColor;
/**
 星星正常的(为填充的背景)颜色
 */
@property (strong ,nonatomic) UIColor *starNormalColor;


/**
 边框颜色
 */
@property (strong ,nonatomic) UIColor * borderColor;

/**
 边框宽度
 */
@property (assign ,nonatomic) CGFloat borderWidth;

@end
