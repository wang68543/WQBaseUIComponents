//
//  WQTipTextField.h
//  WQBaseDemo
//
//  Created by WangQiang on 2017/5/23.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQTipTextField : UITextField
/** 固定左边的宽度 */
@property (assign ,nonatomic) CGFloat leftViewWidth;
/** 提示图片 */
@property (copy ,nonatomic) NSString *imageName;
/** 提示文字 */
@property (copy ,nonatomic) NSString *tipText;

@property (strong ,nonatomic,readonly) UIImageView *leftImageView;
/** 图片的分割线 */
@property (strong ,nonatomic,readonly) UIView *imageLineView;
@property (strong ,nonatomic,readonly) UILabel *leftLabel;

@end
