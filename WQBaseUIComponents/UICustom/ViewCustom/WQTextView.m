//
//  PlacehodelTextView.m
//  Guardian
//
//  Created by WangQiang on 2016/10/14.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQTextView.h"
@interface WQTextView()

@end
@implementation WQTextView{
    UILabel *_placeHolderLabel;
}

@synthesize placeholder = _placeholder;
-(void)commonInit{
    //非通知无法监听到xib创建的textview的文字的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPlaceholder) name:UITextViewTextDidChangeNotification object:nil];
}
- (void)dealloc
{
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self commonInit];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self commonInit];
    }
    return self;
}
-(instancetype)init{
    if(self = [super init]){
        [self commonInit];
    }
    return self;
}

-(void)refreshPlaceholder{
    if([[self text] length])
    {
        [_placeHolderLabel setAlpha:0];
    }
    else
    {
        [_placeHolderLabel setAlpha:1];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self refreshPlaceholder];
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    _placeHolderLabel.font = self.font;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_placeHolderLabel sizeToFit];
    _placeHolderLabel.frame = CGRectMake(8, 8, CGRectGetWidth(self.frame)-16, CGRectGetHeight(_placeHolderLabel.frame));
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    if ( _placeHolderLabel == nil )
    {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = self.font;
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        _placeHolderLabel.alpha = 0;
        [self addSubview:_placeHolderLabel];
    }
    
    _placeHolderLabel.text = self.placeholder;
    [self refreshPlaceholder];
}

//When any text changes on textField, the delegate getter is called. At this time we refresh the textView's placeholder
-(id<UITextViewDelegate>)delegate
{
    [self refreshPlaceholder];
    return [super delegate];
}

@end
