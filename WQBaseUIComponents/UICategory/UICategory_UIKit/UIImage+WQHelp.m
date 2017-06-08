//
//  UIImage+Extension.m
//  黑马微博
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIImage+WQHelp.h"
@implementation UIImage (WQHelp)

- (UIImage *)hu_circleImageWithCornerRadius:(CGFloat)radius
{
    // 利用self生成一张圆形图片
    
    // 1.开启图形上下文
    CGSize size = CGSizeMake(radius*2.0, radius*2.0);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    // 2.描述圆形路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    // 3.设置裁剪区域
    [path addClip];
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 4.画图
//    [self drawAtPoint:CGPointZero blendMode:<#(CGBlendMode)#> alpha:<#(CGFloat)#>];
    
    // 5.取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

/** 圆形图片裁剪 */
+ (UIImage *)hu_circleImageNamed:(NSString *)name cornerRadius:(CGFloat)radius
{
    return [[UIImage imageNamed:name] hu_circleImageWithCornerRadius:radius];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGFloat imageW = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageH = 100;
    // 1.开启基于位图的图形上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0.0);
    
    // 2.画一个color颜色的矩形框
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    
    // 3.拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}
+ (UIImage *)imageInBounds:(CGRect)bounds colors:(NSArray <UIColor *> *)colors subHeights:(NSArray <NSNumber *> *)heights{
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0);

    __block CGFloat drawHeight = 0;
    [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *heightValue = heights[idx];
        CGFloat height = heightValue.floatValue;
        [obj set];
        if(idx == colors.count - 1) height = (int)height;
        
        UIRectFill(CGRectMake(0, drawHeight, bounds.size.width, height));
        drawHeight += height;
    }];
    // 3.拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;

}
+ (UIImage *)imageInBounds:(CGRect)bounds colors:(NSArray <UIColor *> *)colors{
    
    CGFloat subHeight = bounds.size.height /(colors.count *1.0);
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0);
    
    [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 2.画一个color颜色的矩形框
        [obj set];
        UIRectFill(CGRectMake(0, subHeight *idx, bounds.size.width, subHeight));
    }];
    // 3.拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)resizedImage:(NSString *)name size:(CGSize)size
{
    UIImage *imageNormal = [UIImage imageNamed:name];
    CGFloat imageW = imageNormal.size.width*0.5;
    CGFloat imageH = imageNormal.size.height*0.5;
     UIImage *image = [imageNormal resizableImageWithCapInsets:UIEdgeInsetsMake(imageH, imageW, imageH, imageH)];
//     UIGraphicsBeginImageContext(size);
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//      image =  UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)resizedImage:(NSString *)name
{
    UIImage *imageNormal = [UIImage imageNamed:name];
    CGFloat imageW = imageNormal.size.width*0.5;
    CGFloat imageH = imageNormal.size.height*0.5;
//    return [imageNormal stretchableImageWithLeftCapWidth:imageW topCapHeight:imageH];
    return [imageNormal resizableImageWithCapInsets:UIEdgeInsetsMake(imageH, imageW, imageH, imageH)];
}
+ (UIImage *)createCIImageWithText:(NSString*)text length:(CGFloat)length{
    if(text.length <= 0) return [[UIImage alloc] init];
    // 使用CIFilter生成二维码QRCode
    CIFilter *filter = [CIFilter filterWithName: @"CIQRCodeGenerator"];
    NSData *data = [text dataUsingEncoding: NSUTF8StringEncoding];
    // 设置内容
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *ciImage = [filter outputImage];
    CGRect extent = CGRectIntegral(ciImage.extent) ;
    // length为输入的二维码尺寸
    CGFloat scale = MIN(length/CGRectGetWidth(extent), length/CGRectGetHeight(extent));
    // 创建 bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t heigh = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, heigh, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions: nil];
    CGImageRef bitmapImage = [context createCGImage: ciImage fromRect: extent];
    CGContextSetInterpolationQuality( bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM( bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存 bitmap 为图片
    CGImageRef scaleImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage *QRCodeImage = [UIImage imageWithCGImage: scaleImage];
    
    //    if(text.length <= 0) return  [[UIImage alloc] init];
//    CIFilter*filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    
//    NSString*string = text;
//    
//    NSData*data = [string dataUsingEncoding:NSUTF8StringEncoding];
//    
//    //2.通过kVO设置滤镜传入数据
//    
//    [filter setValue:data forKey:@"inputMessage"];
//    
//    //3.生成二维码
//    
//    CIImage*iconImage = [filter outputImage];
//    UIImage*image = [UIImage imageWithCIImage:iconImage];
    return QRCodeImage;
}
-(NSData *)compressImage{
    return [self compressImageToKb:100];
}
-(NSData *)compressImageToKb:(NSInteger)kb{
    NSData *dataImage = UIImageJPEGRepresentation(self, 1.0);
    if (dataImage.length > kb*1024) {
        dataImage = UIImageJPEGRepresentation(self, (kb*1024.0)/(dataImage.length *1.0));
    }
    if(!dataImage) dataImage = UIImagePNGRepresentation(self);
    if(!dataImage) dataImage = [NSData data];
    return dataImage;
}
@end
