//
//  WQTipTextField.m
//  WQBaseDemo
//
//  Created by WangQiang on 2017/5/23.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import "WQTipTextField.h"
@interface WQTipTextField()

@end
@implementation WQTipTextField

static CGFloat const kPadding = 5.0;
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
    _leftViewWidth = 0.0;
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
        
        if(_leftViewWidth <= 0.0){
            _leftViewWidth = image.size.width + kPadding *2 +1.0;
        }
        self.leftViewMode = UITextFieldViewModeAlways;
    }else{
        _leftViewWidth = 0.0;
       self.leftView = nil;
       self.leftViewMode = UITextFieldViewModeNever;
    }
}
//TODO: 用于解决xib创建的时候placeHoldel显示布局不正常的问题
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    return CGRectMake(0, 0, _leftViewWidth, CGRectGetHeight(bounds));
}
-(void)setTipText:(NSString *)tipText{
    _tipText = tipText;
    if(_tipText.length > 0){
        [_leftImageView removeFromSuperview];
        _imageName = nil;
        _leftImageView.image = nil;
        _leftViewWidth =  [self.tipText boundingRectWithSize:CGSizeMake(200, MAX(30, self.frame.size.height)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.leftLabel.font} context:nil].size.width;
        _leftViewWidth += kPadding*2;
        _leftLabel.text = _tipText;
        [self.leftView addSubview:_leftLabel];
        self.leftViewMode = UITextFieldViewModeAlways;
    }else{
        _leftViewWidth = 0.0;
        self.leftView = nil;
        self.leftViewMode = UITextFieldViewModeNever;
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat viewH = CGRectGetHeight(self.frame);
   
    if(self.tipText.length > 0){
       
        self.imageLineView.frame = CGRectZero;
        self.leftLabel.frame = CGRectMake(kPadding, 0, _leftViewWidth - kPadding *2, viewH);
        self.leftView.frame = CGRectMake(0, 0,_leftViewWidth,viewH);
    }else if(self.leftImageView.image){
        CGFloat imageH = self.leftImageView.image.size.height;
        self.leftImageView.frame = CGRectMake(kPadding, (viewH - imageH)*0.5, _leftViewWidth - 2*kPadding - 1.0, imageH);
        self.imageLineView.frame = CGRectMake(CGRectGetMaxX(self.leftImageView.frame), self.leftImageView.frame.origin.y, 1.0, imageH);

        self.leftView.frame = CGRectMake(0, 0,_leftViewWidth,viewH);
    }else{
        self.leftView.frame = CGRectZero;
        self.imageLineView.frame = CGRectZero;
    }
}
@end
