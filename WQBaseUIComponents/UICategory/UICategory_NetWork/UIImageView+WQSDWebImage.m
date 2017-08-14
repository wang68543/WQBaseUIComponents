//
//  UIImageView+SDWebImage.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/10.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "UIImageView+WQSDWebImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (WQSDWebImage)

-(void)downloadImage:(NSString *)url placeholder:(NSString *)imageName{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:imageName]];
}
@end
