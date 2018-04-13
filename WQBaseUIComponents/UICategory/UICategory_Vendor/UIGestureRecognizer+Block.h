//
//  UIGestureRecognizer+Block.h
//  YunShouHu
//
//  Created by WangQiang on 16/4/11.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^NVMGestureBlock) (id gestureRecognizer);
@interface UIGestureRecognizer (Block)
+(instancetype)gestureRecognizerWithActionBlock:(NVMGestureBlock)block;
@end
