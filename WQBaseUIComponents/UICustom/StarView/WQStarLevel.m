//
//  StarLevel.m
//  YunShouHu
//
//  Created by WangQiang on 2016/10/12.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQStarLevel.h"
@interface WQStarLevel(){
    NSMutableArray *starRects ;
}
@end
@implementation WQStarLevel
-(instancetype)init{
    if(self = [super init]){
        [self defaultInit];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self defaultInit];
    }
    return self;
}
-(void)defaultInit{
    _starHighlightedColor = [UIColor redColor];
    _borderColor = [UIColor blackColor];
    _borderWidth = 1.0;
    _starHeight = 15.0;
    _leftPadding = 10.0;
    _starNormalColor = [UIColor lightGrayColor];
    self.backgroundColor = [UIColor whiteColor];
}
-(void)setHideUnHighlited:(BOOL)hideUnHighlited{
    _hideUnHighlited = hideUnHighlited;
    if(hideUnHighlited){
        self.enabled = NO;
    }
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGFloat topPading;
//    if(!self.starHeight){
//        topPading = 10.0;
//        self.starHeight = rect.size.height - topPading *2;
//    }else{
        topPading = (rect.size.height - self.starHeight)*0.5;
//    }
    CGFloat sectionH = 5.0;
    CGFloat starW = self.starHeight;
    BOOL isNeedRects = NO;
    if(!starRects){
        starRects = [NSMutableArray array];
        isNeedRects = YES;
    }
    //获取一个数的小数部分
    //fmodf(float, float) 表示第一个浮点数除以第二个浮点数的余数
    float decimalValue = fmodf(self.starValue, 1.0);
    int integer = (int)floor(self.starValue);
    BOOL highlighted = NO;
    for (int i = 0; i < 5 ; i ++) {
        CGRect rect = CGRectMake(_leftPadding + (starW + sectionH)*i , topPading, starW, self.starHeight);
        //从左到右
        if(isNeedRects){
            [starRects addObject:[NSValue valueWithCGRect:rect]];
        }
        if(i+1 <= self.starValue){
            highlighted = YES;
        }else{
            highlighted = NO;
        }
        if(self.hideUnHighlited && !highlighted) continue;
        if(_drawType == DrawTypeStar){
            if(!_half){
                [self drawSatr:rect isFill:highlighted];
            }else{
                if(decimalValue >= 0.5 && i == integer){
                    [self draStarHalfFill:rect];
                }else{
                    [self drawSatr:rect isFill:highlighted];
                }
            }
        }else if(_drawType == DrawTypeImage){
            [self drawImage:rect isHighlight:highlighted];
        }
        
    }
}

#pragma mark -- 画图片
-(void)drawImage:(CGRect)rect isHighlight:(BOOL)highlight{
    if(highlight){
        [self.highlightImage drawInRect:rect];
    }else{
        [self.normalImage drawInRect:rect];
    }
}
#pragma mark -- 画半颗星填充的
-(void)draStarHalfFill:(CGRect)rect{
    
    //顺时针
    //根据圆来算五角星
    CGFloat radius = rect.size.width *0.5;
    
    //等边五角形每个角的度数是108
    //起始点为五角心的最上面的点与圆形的最高点重合
    /**** 这样剩下的点 每两个点之间都是水平的*/
    
    //离顶点近的水平一对点间间距离
    CGFloat oneGroupWidth = radius *sin(M_PI/180.0*72.0) *2;
    
    //顶点到最近一对顶点的两点间的垂直距离
    CGFloat oneGroupHeight = radius - radius * cos(M_PI/180.0*72.0);
    //离顶点远的水平一对点间间距离
    CGFloat twoGroupWidth = radius * sin(M_PI/180.0*36.0)*2;
    //顶点到远的一对顶点的两点间的垂直距离
    CGFloat twoGroupHeight = radius + radius * cos(M_PI/180.0*36.0);
    
    CGFloat topX  = CGRectGetMidX(rect);
    CGFloat topY  = CGRectGetMinY(rect);
    
    CGFloat oneGroupY = topY + oneGroupHeight;
    CGFloat oneLeftX = topX - oneGroupWidth *0.5;
    CGFloat oneRightX = topX + oneGroupWidth *0.5;
    
    CGFloat twoGroupY = topY + twoGroupHeight;
    CGFloat twoLeftX = topX - twoGroupWidth *0.5;
    CGFloat twoRightX = topX + twoGroupWidth *0.5;
    
    //拐角点坐标 (一共五个拐角点)
    //第一对距离顶点近拐角点 在oneGroup的连线上(y轴与oneGroup相同)
    CGFloat oneTurningGroupWidth = oneGroupHeight * sin(M_PI/180.0*18.0)*2;
    CGFloat oneTurningLeftX = topX - oneTurningGroupWidth*0.5;
    CGFloat oneTurningRightX = topX + oneTurningGroupWidth*0.5;
    CGFloat oneTurningGroupY = oneGroupY;
    //中间一对拐角点的
    //第一对拐角点对应距离第一对顶点的距离
    CGFloat oneTurningToOneGroup = (oneGroupWidth - oneTurningGroupWidth)*0.5;
    
    CGFloat midTurningGroupY = oneTurningToOneGroup * sin(M_PI/180.0*36.0) + oneGroupY;//距离oneGroupWidth的距离 再加上oneGroupWidth的Y值
    CGFloat midTurningGroupWidth = oneGroupWidth - oneTurningToOneGroup * cos(M_PI/180.0*36.0)*2;
    CGFloat midTurningLeftX = topX - midTurningGroupWidth*0.5;
    CGFloat midTurningRightX = topX + midTurningGroupWidth*0.5;
    
    //离顶点最远的拐角点 在顶点与圆心的垂直连线上(x轴与顶点相同)
    CGFloat lastTurningY =  twoGroupY - twoGroupWidth *0.5*tan(M_PI/180.0 *36.0);
    CGFloat lastTurningX = topX;
    
    //半个五角星填充路径
    UIBezierPath *fillPath = [UIBezierPath bezierPath];
    [fillPath moveToPoint:CGPointMake(topX, topY)];
    [fillPath addLineToPoint:CGPointMake(oneTurningLeftX, oneTurningGroupY)];
    [fillPath addLineToPoint:CGPointMake(oneLeftX, oneGroupY)];
    [fillPath addLineToPoint:CGPointMake(midTurningLeftX, midTurningGroupY)];
    [fillPath addLineToPoint:CGPointMake(twoLeftX, twoGroupY)];
    [fillPath addLineToPoint:CGPointMake(lastTurningX, lastTurningY)];
    [fillPath closePath];
    //⭐️
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(topX, topY)];
    [path addLineToPoint:CGPointMake(oneTurningRightX, oneTurningGroupY)];
    [path addLineToPoint:CGPointMake(oneRightX, oneGroupY)];
    [path addLineToPoint:CGPointMake(midTurningRightX, midTurningGroupY)];
    [path addLineToPoint:CGPointMake(twoRightX, twoGroupY)];
    [path addLineToPoint:CGPointMake(lastTurningX, lastTurningY)];
    [path addLineToPoint:CGPointMake(twoLeftX, twoGroupY)];
    [path addLineToPoint:CGPointMake(midTurningLeftX, midTurningGroupY)];
    [path addLineToPoint:CGPointMake(oneLeftX, oneGroupY)];
    [path addLineToPoint:CGPointMake(oneTurningLeftX, oneTurningGroupY)];
    [path addLineToPoint:CGPointMake(topX, topY)];
    [path closePath];
  
    //路径旋转
//    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/180.0 *30.0);
//    [path applyTransform:transform];
//    
    if(_borderWidth > 0.0){
        path.lineWidth = _borderWidth;
        [_borderColor set];
        [path stroke];
    }
    [_starNormalColor set];
    [path fill];
    
    [_starHighlightedColor set];
    [fillPath fill];
    
    
}
-(void)drawSatr:(CGRect)rect isFill:(BOOL)fill{//rect是个正方形
    //顺时针
    //根据圆来算五角星
    CGFloat radius = rect.size.width *0.5;
    
    //等边五角形每个角的度数是108
    //起始点为五角心的最上面的点与圆形的最高点重合
    /**** 这样剩下的点 每两个点之间都是水平的*/
    
    //离顶点近的水平一对点间间距离
    CGFloat oneGroupWidth = radius *sin(M_PI/180.0*72.0) *2;
    
    //顶点到最近一对顶点的两点间的垂直距离
    CGFloat oneGroupHeight = radius - radius * cos(M_PI/180.0*72.0);
    //离顶点远的水平一对点间间距离
    CGFloat twoGroupWidth = radius * sin(M_PI/180.0*36.0)*2;
    //顶点到远的一对顶点的两点间的垂直距离
    CGFloat twoGroupHeight = radius + radius * cos(M_PI/180.0*36.0);
    
    CGFloat topX  = CGRectGetMidX(rect);
    CGFloat topY  = CGRectGetMinY(rect);
    
    CGFloat oneGroupY = topY + oneGroupHeight;
    CGFloat oneLeftX = topX - oneGroupWidth *0.5;
    CGFloat oneRightX = topX + oneGroupWidth *0.5;
    
    CGFloat twoGroupY = topY + twoGroupHeight;
    CGFloat twoLeftX = topX - twoGroupWidth *0.5;
    CGFloat twoRightX = topX + twoGroupWidth *0.5;
    
    //拐角点坐标 (一共五个拐角点)
    //第一对距离顶点近拐角点 在oneGroup的连线上(y轴与oneGroup相同)
    CGFloat oneTurningGroupWidth = oneGroupHeight * sin(M_PI/180.0*18.0)*2;
    CGFloat oneTurningLeftX = topX - oneTurningGroupWidth*0.5;
    CGFloat oneTurningRightX = topX + oneTurningGroupWidth*0.5;
    CGFloat oneTurningGroupY = oneGroupY;
    //中间一对拐角点的
    //第一对拐角点对应距离第一对顶点的距离
    CGFloat oneTurningToOneGroup = (oneGroupWidth - oneTurningGroupWidth)*0.5;
    
    CGFloat midTurningGroupY = oneTurningToOneGroup * sin(M_PI/180.0*36.0) + oneGroupY;//距离oneGroupWidth的距离 再加上oneGroupWidth的Y值
    CGFloat midTurningGroupWidth = oneGroupWidth - oneTurningToOneGroup * cos(M_PI/180.0*36.0)*2;
    CGFloat midTurningLeftX = topX - midTurningGroupWidth*0.5;
    CGFloat midTurningRightX = topX + midTurningGroupWidth*0.5;
    
    //离顶点最远的拐角点 在顶点与圆心的垂直连线上(x轴与顶点相同)
    CGFloat lastTurningY =  twoGroupY - twoGroupWidth *0.5*tan(M_PI/180.0 *36.0);
    CGFloat lastTurningX = topX;
    
//    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/180.0 *30.0);

    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(topX, topY)];
    [path addLineToPoint:CGPointMake(oneTurningRightX, oneTurningGroupY)];
    [path addLineToPoint:CGPointMake(oneRightX, oneGroupY)];
    [path addLineToPoint:CGPointMake(midTurningRightX, midTurningGroupY)];
    [path addLineToPoint:CGPointMake(twoRightX, twoGroupY)];
    [path addLineToPoint:CGPointMake(lastTurningX, lastTurningY)];
    [path addLineToPoint:CGPointMake(twoLeftX, twoGroupY)];
    [path addLineToPoint:CGPointMake(midTurningLeftX, midTurningGroupY)];
    [path addLineToPoint:CGPointMake(oneLeftX, oneGroupY)];
    [path addLineToPoint:CGPointMake(oneTurningLeftX, oneTurningGroupY)];
    [path addLineToPoint:CGPointMake(topX, topY)];
    [path closePath];
//    [path applyTransform:transform];
    
    if(_borderWidth > 0.0){
        path.lineWidth = _borderWidth;
        [_borderColor set];
        [path stroke];
    }
    if(fill){
        [_starHighlightedColor set];
    }else{
        [_starNormalColor set];
    }
     [path fill];
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    if(!self.isFirstResponder){
        [self becomeFirstResponder];
    }
    [self handleTouch:touch];
    return YES;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    [self handleTouch:touch];
    return YES;
}
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    if(self.isFirstResponder){
        [self resignFirstResponder];
    }
    [self handleTouch:touch];
}

-(void)handleTouch:(UITouch *)touch{
    CGPoint point = [touch locationInView:self];
    __weak typeof(self) weakSelf = self;
    [starRects enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = [obj CGRectValue];
        if(idx == 0 && point.x < rect.origin.x){
            weakSelf.starValue = 0;
            *stop = YES;
        }else if(!weakSelf.half){  //这个是不支持半颗星的
            if(CGRectContainsPoint(rect, point)){
                weakSelf.starValue = idx+1;
                *stop = YES;
            }
        }else{
            //这个是支持半颗星的
            if(CGRectContainsPoint(rect, point)){
                if(point.x > CGRectGetMidX(rect)){
                    weakSelf.starValue = idx+1;
                }else{
                    weakSelf.starValue = idx+0.5;
                }
                *stop = YES;
            }
        }
    }];
}

-(void)setStarValue:(CGFloat)starValue{
    if(_starValue != starValue){
        _starValue = starValue;
        [self setNeedsDisplay];
        if(self.enabled){
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        
    }
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}
@end
