//
//  WQRadioGroup.m
//  WQBaseUIDemo
//
//  Created by WangQiang on 2017/6/12.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import "WQRadioGroup.h"
@implementation UIButton(WQRadioButton)
+(instancetype)radioTitle:(NSString *)title selectedTitle:(NSString *)selTitle titleColor:(UIColor *)titleColor selectedTitleColor:(UIColor *)selColor image:(NSString *)imageName selectedImage:(NSString *)selImageName{
    return [[self alloc] initTitle:title selectedTitle:selTitle titleColor:titleColor selectedTitleColor:selColor image:imageName selectedImage:selImageName];
}

-(instancetype)initTitle:(NSString *)title selectedTitle:(NSString *)selTitle titleColor:(UIColor *)titleColor selectedTitleColor:(UIColor *)selColor image:(NSString *)imageName selectedImage:(NSString *)selImageName{
    if(self = [super init]){
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        [self setTitle:selTitle forState:UIControlStateSelected];
        [self setTitleColor:selColor forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
        
    }
    return self;
}

@end
@implementation WQRadioGroup
+(instancetype)radioGroupWithButtons:(NSArray<UIButton *> *)btns{
    return [[self alloc] initWithButtons:btns];
}
-(instancetype)initWithButtons:(NSArray<UIButton *> *)btns{
    if(self = [super init]){
        _buttons = btns;
        _mustSelection = YES;
        for (UIButton *btn in self.buttons) {
            [btn addTarget:self action:@selector(radioChange:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        [[self.buttons firstObject] setSelected:YES];
        _selectedIndex = 0;
    }
    return self;
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex{
    if(selectedIndex < self.buttons.count){
        _selectedIndex = selectedIndex;
        [self cancelAllButtonsSelection];
        [self.buttons[selectedIndex] setSelected:YES];
    }
}

- (void)radioChange:(UIButton *)sender{
    //必须选中一个的时候 不能取消选中
    if(self.mustSelection && sender.isSelected) return;
    NSInteger index = [self.buttons indexOfObject:sender];
    if(sender.isSelected){
        _selectedIndex = NSNotFound;
    }else{
        [self cancelAllButtonsSelection];
         sender.selected = YES;
        _selectedIndex = index;
        
    }
}
//MARK: --私有方法
//取消所有按钮的选中方式
- (void)cancelAllButtonsSelection{
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.isSelected){
            obj.selected = NO;
            *stop = YES;
        }
    }];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat buttonH = CGRectGetHeight(self.frame);
    CGFloat buttonW = CGRectGetWidth(self.frame)/(self.buttons.count*1.0);
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(idx*buttonW, 0.0, buttonW, buttonH);
    }];
}
@end
