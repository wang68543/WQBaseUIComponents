//
//  WQStepNumberView.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/5/8.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQStepNumberView.h"
@interface WQStepNumberView()

@property (strong ,nonatomic) UIView *tfTopLine;
@property (strong ,nonatomic) UIView *tfBottomLine;


@end
@implementation WQStepNumberView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _addButton = [[UIButton alloc] init];
        [_addButton setImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(changeStepCount:) forControlEvents:UIControlEventTouchUpInside];
        _subtractButton = [[UIButton alloc] init];
        [_subtractButton setImage:[UIImage imageNamed:@"减"] forState:UIControlStateNormal];
        [_subtractButton addTarget:self action:@selector(changeStepCount:) forControlEvents:UIControlEventTouchUpInside];
        _addButton.adjustsImageWhenHighlighted = NO;
        _subtractButton.adjustsImageWhenHighlighted = NO;
        [self addSubview:_addButton];
        [self addSubview:_subtractButton];
        
        _countNumTextField = [[UITextField alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledDidChange:) name:UITextFieldTextDidChangeNotification object:_countNumTextField];
        _countNumTextField.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_countNumTextField];
        
        UIColor *borderColor = [UIColor colorWithRed:47.0/255.0 green:192.0/255.0 blue:187.0/255.0 alpha:1.0];
        
        _tfTopLine = [[UIView alloc] init];
        _tfTopLine.backgroundColor = borderColor;
        _tfBottomLine = [[UIView alloc] init];
        _tfBottomLine.backgroundColor = borderColor;
        [self addSubview:_tfBottomLine];
        [self addSubview:_tfTopLine];
        
        self.isStepFloat = NO;
        _stepValue = 1.0;
        _minValue = 1.0;
    }
    return self;
}

-(void)textFiledDidChange:(NSNotification *)note{
    if(note.object == _countNumTextField){
        if([self.delegate respondsToSelector:@selector(stepNumberView:didChange:)]){
            [self.delegate stepNumberView:self didChange:self.numberValue];
        }
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat subW = CGRectGetWidth(self.frame)/3.0;
    CGFloat subH =CGRectGetHeight(self.frame);
    
    CGFloat imageW = 32.0;
    CGFloat addW = (subW - imageW)*0.5+5.0;
    self.subtractButton.frame = CGRectMake(0, 0, subW, subH);
    self.countNumTextField.frame = CGRectMake(CGRectGetMaxX(self.subtractButton.frame), (subH - imageW)*0.5, subW, imageW);
    self.tfTopLine.frame = CGRectMake(self.countNumTextField.frame.origin.x-addW, (subH - imageW)*0.5+0.5, subW+addW*2, 1.0);
    self.tfBottomLine.frame = CGRectMake(self.countNumTextField.frame.origin.x - addW, self.countNumTextField.frame.size.height - 1.0+self.countNumTextField.frame.origin.y, subW+addW*2, 1.0);
    self.addButton.frame = CGRectMake(CGRectGetMaxX(self.countNumTextField.frame), 0, subW, subH);
}
@synthesize numberValue = _numberValue;
-(CGFloat)numberValue{
    return [self.countNumTextField.text floatValue];
}
-(void)setNumberValue:(CGFloat)numberValue{
    if(numberValue < _minValue) return;
    _numberValue = numberValue;
    if(self.isStepFloat){
        _countNumTextField.text = [NSString stringWithFormat:@"%.2f",numberValue];
    }else{
       _countNumTextField.text = [NSString stringWithFormat:@"%.0f",numberValue];
    }
    if([self.delegate respondsToSelector:@selector(stepNumberView:didChange:)]){
        [self.delegate stepNumberView:self didChange:self.numberValue];
    }
}
-(void)setIsStepFloat:(BOOL)isStepFloat{
    _isStepFloat = isStepFloat;
    if(isStepFloat){
        self.countNumTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }else{
        self.countNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
}
- (void)changeStepCount:(UIButton *)sender{
    if(sender == self.subtractButton){
        self.numberValue -= self.stepValue;
    }else{
        self.numberValue += self.stepValue;
    }
}
@end
