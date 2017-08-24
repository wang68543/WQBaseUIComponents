//
//  UIImage+Extension.h
//  黑马微博
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WQHelp)
/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;
+ (UIImage *)resizedImage:(NSString *)name size:(CGSize)size;


/**
 根据颜色创建一个默认的图片

 @return 一个尺寸为(屏幕宽,100)的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/** 创建一个多钟颜色的图片 */
+ (UIImage *)imageInBounds:(CGRect)bounds colors:(NSArray <UIColor *> *)colors;
+ (UIImage *)imageInBounds:(CGRect)bounds colors:(NSArray <UIColor *> *)colors subHeights:(NSArray <NSNumber *> *)heights;
//生成二维码图片
+ (UIImage *)createQRCodeWithText:(NSString*)text length:(CGFloat)length;

/**
 同步图片裁剪

 @param size 图片尺寸
 @param fillColor 图片填充背景
 @param path 图片裁剪路径
 @return 裁剪后的图片
 */
- (UIImage *)wq_syncCornerImage:(CGSize)size fillColor:(UIColor *)fillColor clipPath:(UIBezierPath *)path;

/**
 绘制一个圆形的图片
 */
-(UIImage *)wq_circleImage:(CGSize)size fillColor:(UIColor *)fillColor;
/** 异步绘制一个圆形图片 */
- (void)wq_asyncCicleImage:(CGSize)size fillColor:(UIColor *)fillColor compeletion:(void (^)(UIImage *))completion;

/**
 压缩图片到指定的尺寸
 
 @param kb 单位kb
 */
-(NSData *)compressImageToKb:(NSInteger)kb;

/** 将图片设置为向上 */
- (UIImage *)fixOrientation;
@end
