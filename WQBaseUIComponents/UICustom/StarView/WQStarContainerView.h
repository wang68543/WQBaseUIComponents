//
//  WQStarContainerView.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/5/8.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQStarLevel.h"

@interface WQStarContainerView : UIView

+(instancetype)starContainerWithFrame:(CGRect)frame
                         messageWidth:(CGFloat)messageWidth
                              message:(NSString *)message;
/** 提示信息 */
@property (strong ,nonatomic,readonly) UILabel *promptMessage;
/** 评分控件 */
@property (strong ,nonatomic,readonly) WQStarLevel *starControl;

@end
