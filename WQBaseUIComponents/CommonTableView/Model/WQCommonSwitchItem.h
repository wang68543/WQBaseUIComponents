//
//  WQCommonSwitchItem.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/13.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQCommonBaseItem.h"

@interface WQCommonSwitchItem : WQCommonBaseItem
@property (assign ,nonatomic,getter=isSwitchOn) BOOL switchOn;

/** 默认YES */
@property (assign ,nonatomic) BOOL switchEnabled;
@end
