//
//  UIGestureRecognizer+Block.m
//  YunShouHu
//
//  Created by WangQiang on 16/4/11.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "UIGestureRecognizer+Block.h"
#import <objc/message.h>
static const int target_key;
@implementation UIGestureRecognizer (Block)
+(instancetype)gestureRecognizerWithActionBlock:(NVMGestureBlock)block{
    return [[self alloc]initWithActionBlock:block];
}
+(instancetype)nvm_gestureRecognizerWithActionBlock:(NVMGestureBlock)block {
    return [[self alloc]initWithActionBlock:block];
}
- (instancetype)initWithActionBlock:(NVMGestureBlock)block {
    self = [self init];
    [self addActionBlock:block];
    [self addTarget:self action:@selector(invoke:)];
    return self;
}
- (void)addActionBlock:(NVMGestureBlock)block {
    if (block) {
        objc_setAssociatedObject(self, &target_key, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}
- (void)invoke:(id)sender {

    NVMGestureBlock block = objc_getAssociatedObject(self, &target_key);
    if (block) {
        block(sender);
    }
}
@end
