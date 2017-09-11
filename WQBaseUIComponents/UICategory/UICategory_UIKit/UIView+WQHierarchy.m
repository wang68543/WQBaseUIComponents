//
//  UIView+WQHierarchy.m
//  WQBaseUIDemo
//
//  Created by hejinyin on 2017/9/11.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import "UIView+WQHierarchy.h"

@implementation UIView (WQHierarchy)
- (UIImage *)snapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, self.window.screen.scale);
    
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        // iOS7 API
        [self drawViewHierarchyInRect:self.frame afterScreenUpdates:NO];
    } else {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.layer renderInContext:context];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return image;
}
@end
