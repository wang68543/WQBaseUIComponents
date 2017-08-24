//
//  UIImage+Extension.m
//  黑马微博
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIImage+WQHelp.h"
@implementation UIImage (WQHelp)
+(UIImage *)imageWithColor:(UIColor *)color{
    return [self imageInBounds:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100) colors:@[color]];
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
    return image;
}

+ (UIImage *)resizedImage:(NSString *)name{
    UIImage *imageNormal = [UIImage imageNamed:name];
    CGFloat imageW = imageNormal.size.width*0.5;
    CGFloat imageH = imageNormal.size.height*0.5;
    return [imageNormal resizableImageWithCapInsets:UIEdgeInsetsMake(imageH, imageW, imageH, imageH)];
}
+ (UIImage *)createQRCodeWithText:(NSString*)text length:(CGFloat)length{
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



//TODO: -- -图片裁剪
- (UIImage *)wq_syncCornerImage:(CGSize)size fillColor:(UIColor *)fillColor clipPath:(UIBezierPath *)path{
    // 1. 利用绘图，建立上下文
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    // 2. 设置填充颜色
    [fillColor setFill];
    UIRectFill(rect);
    
    // 3. 利用 贝赛尔路径 `裁切 效果
    [path addClip];
    
    // 4. 绘制图像
    [self drawInRect:rect];
    
    // 5. 取得结果
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6. 关闭上下文
    UIGraphicsEndImageContext();
    
    return result;

}

//TODO: -- -绘制一个圆形的图片
-(UIImage *)wq_circleImage:(CGSize)size fillColor:(UIColor *)fillColor{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    return [self wq_syncCornerImage:size fillColor:fillColor clipPath:path];
}
//TODO: -- -异步绘制一个圆形图片
- (void)wq_asyncCicleImage:(CGSize)size fillColor:(UIColor *)fillColor compeletion:(void (^)(UIImage *))completion{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *cicrleImage = [self wq_circleImage:size fillColor:fillColor];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion != nil) {
                completion(cicrleImage);
            }
        });
    });
}

//TODO: -- -压缩图片
-(NSData *)compressImageToKb:(NSInteger)kb{
    NSData *dataImage = UIImageJPEGRepresentation(self, 1.0);
    if (dataImage.length > kb*1024) {
        dataImage = UIImageJPEGRepresentation(self, (kb*1024.0)/(dataImage.length *1.0));
    }
    if(!dataImage) dataImage = UIImagePNGRepresentation(self);
    if(!dataImage) dataImage = [NSData data];
    return dataImage;
}

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
