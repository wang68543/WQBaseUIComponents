//
//  WQTipTextField.m
//  WQBaseDemo
//
//  Created by WangQiang on 2017/5/23.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import "WQTipTextField.h"

@implementation WQTipTextField
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self commonInit];
}
-(void)commonInit{
    _leftImageView = [[UIImageView alloc] init];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    _leftLabel = [[UILabel alloc] init];
    _leftLabel.textAlignment = NSTextAlignmentRight;
    self.leftView = [[UIView alloc] init];
    _imageLineView = [[UIView alloc] init];
    _imageLineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
}
-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    UIImage *image = [UIImage imageNamed:imageName];
    if(image){
        [_leftLabel removeFromSuperview];
        _tipText = nil;
        _leftLabel.text = nil;
        
       _leftImageView.image = image;
        [self.leftView addSubview:_leftImageView];
        [self.leftView addSubview:_imageLineView];
        self.leftViewMode = UITextFieldViewModeAlways;
    }else{
       self.leftView = nil;
       self.leftViewMode = UITextFieldViewModeNever;
    }
    [self layoutIfNeeded];
}
-(void)setTipText:(NSString *)tipText{
    _tipText = tipText;
    if(_tipText.length > 0){
        [_leftImageView removeFromSuperview];
        _imageName = nil;
        _leftImageView.image = nil;
        
        _leftLabel.text = _tipText;
        [self.leftView addSubview:_leftLabel];
        self.leftViewMode = UITextFieldViewModeAlways;
    }else{
        self.leftView = nil;
        self.leftViewMode = UITextFieldViewModeNever;
    }
    [self layoutIfNeeded];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat viewH = CGRectGetHeight(self.frame);
    CGFloat contentW = self.leftViewWidth;
    CGFloat padding = 5.0;
    if(self.tipText.length > 0){
        if(contentW <= 0){
           contentW =  [self.tipText boundingRectWithSize:CGSizeMake(200, viewH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.leftLabel.font} context:nil].size.width;
        }
        self.imageLineView.frame = CGRectZero;
        self.leftLabel.frame = CGRectMake(padding, 0, contentW, viewH);
         self.leftView.frame = CGRectMake(0, 0,contentW+padding *2,viewH);
    }else if(self.leftImageView.image){
        CGFloat imageH = self.leftImageView.image.size.height;
        if(contentW <= 0){
            contentW = self.leftImageView.image.size.width;
        }
        self.leftImageView.frame = CGRectMake(padding, (viewH - imageH)*0.5, contentW, imageH);
        self.imageLineView.frame = CGRectMake(CGRectGetMaxX(self.leftImageView.frame), self.leftImageView.frame.origin.y, 1.0, imageH);
        self.leftView.frame = CGRectMake(0, 0,contentW+padding *2+CGRectGetWidth(self.imageLineView.frame),viewH);
    }else{
        self.leftView.frame = CGRectZero;
        self.imageLineView.frame = CGRectZero;
    }

}
@end
