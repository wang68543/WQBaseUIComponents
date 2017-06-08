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
 *  根据颜色返回一张该颜色的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;
+ (UIImage *)resizedImage:(NSString *)name size:(CGSize)size;
- (UIImage *)hu_circleImageWithCornerRadius:(CGFloat)radius;
+ (UIImage *)hu_circleImageNamed:(NSString *)name cornerRadius:(CGFloat)radius;

+ (UIImage *)imageInBounds:(CGRect)bounds colors:(NSArray <UIColor *> *)colors;
+ (UIImage *)imageInBounds:(CGRect)bounds colors:(NSArray <UIColor *> *)colors subHeights:(NSArray <NSNumber *> *)heights;
//生成二维码图片
+ (UIImage *)createCIImageWithText:(NSString*)text length:(CGFloat)length;
/**
 压缩图片到指定的尺寸
 
 @param kb 单位kb
 */
-(NSData *)compressImageToKb:(NSInteger)kb;

//压缩图片
-(NSData *)compressImage;

@end
