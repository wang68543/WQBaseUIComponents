//
//  WQStarContainerView.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/5/8.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQStarContainerView.h"

@implementation WQStarContainerView

+(instancetype)starContainerWithFrame:(CGRect)frame
                         messageWidth:(CGFloat)messageWidth
                              message:(NSString *)message{
    return [[self alloc] initWithFrame:frame messageWidth:messageWidth message:message];
}
-(instancetype)initWithFrame:(CGRect)frame
                     messageWidth:(CGFloat)messageWidth
                     message:(NSString *)message{
    if(self = [super initWithFrame:frame]){
        _promptMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, messageWidth, frame.size.height)];
        _promptMessage.font = [UIFont systemFontOfSize:15.0];
        _promptMessage.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _promptMessage.text = message;
        [self addSubview:_promptMessage];
        
        _starControl = [[WQStarLevel alloc] init];
        _starControl.starHeight = frame.size.height - 10.0;
        _starControl.frame = CGRectMake(CGRectGetMaxX(_promptMessage.frame)+5.0, 0.0, frame.size.width -(CGRectGetMaxX(_promptMessage.frame)+5.0) , frame.size.height);
        [self addSubview:_starControl];
    }
    return self;
}
@end
