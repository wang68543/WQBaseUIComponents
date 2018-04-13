//
//  WQCommonArrowItem.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/13.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQCommonBaseItem.h"

/** 设置控制器View的背景颜色 */
static NSString *const kViewBackgroundColor = @"view.backgroundColor";
/** 标题 */
static NSString *const kTitle = @"title";

@interface WQCommonArrowItem : WQCommonBaseItem
/**红色提示数字 值为NSNotFound的时候显示为小红点 */
@property (assign ,nonatomic) NSInteger bageValue;

@property (assign ,nonatomic) Class destClass;


/**
 将要跳转的页面携带的一些参数
 */
@property (strong ,nonatomic) NSDictionary *destPropertyParams;

@end
