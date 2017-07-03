//
//  KDBottomTitleButton.h
//  KD_3.0
//
//  Created by WangQiang on 15/10/9.
//  Copyright © 2015年 JunJun. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger , ButtonTitleAliment){
    ButtonTitleAlimentRight,//默认样式
    ButtonTitleAlimentLeft,//标题在左边
    ButtonTitleAlimentTop,
    ButtonTitleAlimentBottom,
};

@interface WQEdgeTitleButton : UIButton
@property (assign ,nonatomic) ButtonTitleAliment  titleAliment;
@property (assign ,nonatomic) CGSize imageSize;

- (void)addImageViewBorder:(CGFloat)with cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor;
@end
