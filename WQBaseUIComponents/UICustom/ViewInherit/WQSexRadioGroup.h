//
//  WQSexRadioGroup.h
//  WQBaseUIDemo
//
//  Created by WangQiang on 2017/6/12.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import "WQRadioGroup.h"

@interface WQSexRadioGroup : WQRadioGroup
+(instancetype)sexRadioGoupWith;
@property (strong ,nonatomic,readonly) UIButton *btn_first;
@property (strong ,nonatomic,readonly) UIButton *btn_second;

@end
