//
//  KDBottomTitleButton.m
//  KD_3.0
//
//  Created by WangQiang on 15/10/9.
//  Copyright © 2015年 JunJun. All rights reserved.
//

#import "WQEdgeTitleButton.h"
@interface WQEdgeTitleButton(){
//    UIEdgeInsets _edge;
//    CGFloat _textPadding;
}
@property (assign ,nonatomic) CGSize titleSize;
@end
@implementation WQEdgeTitleButton
-(instancetype)init{
    if(self = [super init]){
        //图片与文字之前的最小间隔
//        _edge = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
//         _textPadding = 3.0;//文字与图片之间的间距
        self.titleLabel.numberOfLines = 0;
        self.titleEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
        self.imageView.backgroundColor = [UIColor clearColor];
    }
    return self;
}
/**
 *  设置内部图标的frame 在调这个方法之前会调用-(void)setImage:(UIImage *)image forState:(UIControlState)state
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
//    NSLog(@"%s == %@",__func__,NSStringFromCGRect(contentRect));
    //这里是用来防止图片过大的
    
//    BOOL hasImage = [self imageForState:UIControlStateNormal] || [self imageForState:UIControlStateSelected] || [self imageForState:UIControlStateHighlighted];
    BOOL hasImage ;
    if(self.currentImage){
        hasImage = YES;
    }else{
        hasImage = NO;
    }
    if(!hasImage){
        return CGRectZero;
    }
    
    BOOL hasText = [self titleForState:UIControlStateNormal] || [self titleForState:UIControlStateSelected] || [self titleForState:UIControlStateHighlighted];
    
    CGFloat imageW ;
    CGFloat imageH ;
    imageW = MIN(self.imageSize.width, contentRect.size.width);
    imageH = MIN(self.imageSize.height, contentRect.size.width);

    
    CGFloat imageY = 0;
    CGFloat imageX = 0;
   
    CGFloat titleH =  self.titleSize.height ;
    CGFloat titleW =  self.titleSize.width;
    
//    CGFloat contentH = hasText ? (imageH + titleH + _textPadding):imageH;
    
    switch (self.contentVerticalAlignment) {//垂直
        case UIControlContentVerticalAlignmentTop:
            switch (self.titleAliment) {
                case ButtonTitleAlimentTop:
                    imageY = hasText ? self.titleEdgeInsets.bottom+self.imageEdgeInsets.top+titleH+self.contentEdgeInsets.top :self.imageEdgeInsets.top+self.contentEdgeInsets.top;
                    break;
                case ButtonTitleAlimentLeft:
                case ButtonTitleAlimentBottom:
                case ButtonTitleAlimentRight:
                default:
                    imageY = self.imageEdgeInsets.top+self.contentEdgeInsets.top;
                    break;
            }
            break;
        case UIControlContentVerticalAlignmentBottom:
            switch (self.titleAliment) {
                case ButtonTitleAlimentBottom:
                    imageY = contentRect.size.height - titleH - imageH - self.titleEdgeInsets.bottom - (self.imageEdgeInsets.bottom + self.titleEdgeInsets.top)+contentRect.origin.y;
                    break;
                    
                case ButtonTitleAlimentTop:
                case ButtonTitleAlimentLeft:
                case ButtonTitleAlimentRight:
                default:
                    imageY = contentRect.size.height - self.imageEdgeInsets.bottom - imageH+contentRect.origin.y;
                    break;
            }
            break;
            
            
        case UIControlContentVerticalAlignmentFill:
            switch (self.titleAliment) {
                case ButtonTitleAlimentTop:
                    imageY =  contentRect.origin.y + contentRect.size.height - imageH - self.imageEdgeInsets.bottom;
                    break;
                    
                case ButtonTitleAlimentBottom:
                    imageY = contentRect.origin.y + self.imageEdgeInsets.top;
                    break;
                case ButtonTitleAlimentLeft:
                case ButtonTitleAlimentRight:
                default:
                    imageY = (contentRect.size.height - imageH)*0.5+contentRect.origin.y;
                    break;
            }
            break;
        case UIControlContentVerticalAlignmentCenter:
        default:
            switch (self.titleAliment) {
                case ButtonTitleAlimentTop:
                    imageY =  contentRect.size.height - (contentRect.size.height - titleH - imageH - self.titleEdgeInsets.bottom - self.imageEdgeInsets.top)*0.5 - imageH ;
                    break;
                    
                case ButtonTitleAlimentBottom:
                    imageY =  (contentRect.size.height - titleH - imageH - self.titleEdgeInsets.top - self.imageEdgeInsets.bottom)*0.5;
                    break;
                case ButtonTitleAlimentLeft:
                case ButtonTitleAlimentRight:
                default:
                    imageY = (contentRect.size.height - imageH)*0.5;
                    break;
            }
            break;
    }
//    CGFloat imageCenterX = (contentRect.size.width - titleW)*0.5;
//    CGFloat contentW = hasText ? (imageW + titleW + _textPadding):imageW;
    
    switch (self.contentHorizontalAlignment) {
        case UIControlContentHorizontalAlignmentLeft:
            switch (self.titleAliment) {
                case ButtonTitleAlimentLeft:
                    imageX = self.titleEdgeInsets.left + titleW + self.imageEdgeInsets.left + contentRect.origin.x;
                    break;
                case ButtonTitleAlimentBottom:
                case ButtonTitleAlimentRight:
                case ButtonTitleAlimentTop:
                default:
                    imageX = self.imageEdgeInsets.left + contentRect.origin.x;
                    break;
            }
            break;
        case UIControlContentHorizontalAlignmentRight:
            switch (self.titleAliment) {
                case ButtonTitleAlimentRight:
                    imageX = contentRect.origin.x + contentRect.size.width - titleW - imageW - self.titleEdgeInsets.left - self.titleEdgeInsets.right - self.imageEdgeInsets.right;
                    break;
                case ButtonTitleAlimentBottom:
                case ButtonTitleAlimentLeft:
                case ButtonTitleAlimentTop:
                default:
                    imageX = contentRect.origin.x + contentRect.size.width - self.imageEdgeInsets.right - imageW;
                    break;
            }
            break;
        case UIControlContentHorizontalAlignmentFill:
            switch (self.titleAliment) {
                case ButtonTitleAlimentLeft:
                    imageX =contentRect.origin.x + (contentRect.size.width - imageW - self.imageEdgeInsets.right);
                    break;
                case ButtonTitleAlimentRight:
                    imageX = contentRect.origin.x +  self.imageEdgeInsets.left;
                    break;
                case ButtonTitleAlimentBottom:
                case ButtonTitleAlimentTop:
                default:
                    imageX = contentRect.origin.x + (contentRect.size.width - imageW) * 0.5 ;
                    break;
            }
            break;
        case UIControlContentHorizontalAlignmentCenter:
        default:
            switch (self.titleAliment) {
                case ButtonTitleAlimentLeft:
                    imageX = (contentRect.size.width - imageW - titleW - self.imageEdgeInsets.left - self.titleEdgeInsets.right) * 0.5 + titleW +self.imageEdgeInsets.left + self.titleEdgeInsets.right;
                    break;
                case ButtonTitleAlimentRight:
                    imageX = (contentRect.size.width  - imageW - titleW - self.imageEdgeInsets.left - self.titleEdgeInsets.right) * 0.5 ;
                    break;
                case ButtonTitleAlimentBottom:
                case ButtonTitleAlimentTop:
                default:
                    imageX = (contentRect.size.width - imageW) * 0.5 ;
                    break;
            }
            break;
    }

 
    return CGRectMake(imageX, imageY, imageW, imageH);
}

/**
 *  设置内部文字的frame 在调这个方法之前会调用- (void)setTitle:(NSString *)title forState:(UIControlState)state
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
//    NSLog(@"%s == %@",__func__,NSStringFromCGRect(contentRect));
    
    //文字的布局依赖于图片的布局完成
//    BOOL hasText = [self titleForState:UIControlStateNormal] || [self titleForState:UIControlStateSelected] || [self titleForState:UIControlStateHighlighted];
     BOOL hasText = self.currentTitle.length > 0;
    if(!hasText){
        return CGRectZero;
    }
    
    CGFloat titleY = 0;
    
    CGFloat titleX = 0;
    
    CGFloat titleH = self.titleSize.height;
    
    CGFloat titleW = self.titleSize.width;
    
  
    
    CGRect imageFrame = [self imageRectForContentRect:contentRect];
    //是否有图片
    BOOL hasImage = [self imageForState:UIControlStateNormal] || [self imageForState:UIControlStateSelected] || [self imageForState:UIControlStateHighlighted];
   
    
      CGFloat titleCenterY = (contentRect.size.height - titleH)*0.5;
    
        switch (self.contentVerticalAlignment) {//垂直
            case UIControlContentVerticalAlignmentTop:
                switch (self.titleAliment) {
                    case ButtonTitleAlimentBottom:
                        titleY = hasImage ? CGRectGetMaxY(imageFrame) + self.imageEdgeInsets.bottom + self.titleEdgeInsets.top  : self.titleEdgeInsets.top;
                        break;
                        
                    case ButtonTitleAlimentLeft:
                    case ButtonTitleAlimentTop:
                    case ButtonTitleAlimentRight:
                    default:
                        titleY = self.titleEdgeInsets.top + contentRect.origin.y;
                        break;
                }
                break;
            case UIControlContentVerticalAlignmentBottom:
                switch (self.titleAliment) {
                    case ButtonTitleAlimentTop:
                        titleY = hasImage? contentRect.size.height - CGRectGetMinY(imageFrame)- self.titleEdgeInsets.bottom - self.imageEdgeInsets.top - titleH : contentRect.size.height  - titleH - self.titleEdgeInsets.bottom;
                        break;
                        
                    case ButtonTitleAlimentBottom:
                    case ButtonTitleAlimentLeft:
                    case ButtonTitleAlimentRight:
                    default:
                        titleY = CGRectGetMaxY(contentRect) - self.titleEdgeInsets.bottom - titleH;
                        break;
                }
                break;
            case UIControlContentVerticalAlignmentFill:
                switch (self.titleAliment) {
                    case ButtonTitleAlimentTop:
                        titleY = hasImage? (contentRect.size.height - CGRectGetMinY(imageFrame) - titleH)*0.5 :titleCenterY ;
                        break;
                        
                    case ButtonTitleAlimentBottom:
                        titleY = hasImage?(contentRect.size.height - CGRectGetMaxY(imageFrame) - titleH)*0.5 + CGRectGetMaxY(imageFrame):titleCenterY;
                        break;
                    case ButtonTitleAlimentLeft:
                    case ButtonTitleAlimentRight:
                    default:
                        titleY = titleCenterY;
                        break;
                }
                break;
            case UIControlContentVerticalAlignmentCenter:
            default:
                switch (self.titleAliment) {
                    case ButtonTitleAlimentTop:
                        titleY = hasImage ? CGRectGetMinY(imageFrame)-self.imageEdgeInsets.top - self.titleEdgeInsets.bottom - titleH : titleCenterY;
                        break;
                        
                    case ButtonTitleAlimentBottom:
                        titleY = hasImage ?CGRectGetMaxY(imageFrame) + self.imageEdgeInsets.top + self.titleEdgeInsets.bottom : titleCenterY;
                        break;
                    case ButtonTitleAlimentLeft:
                    case ButtonTitleAlimentRight:
                    default:
                        titleY = titleCenterY ;
                        break;
                }
                break;
        }
    CGFloat titleCenterX = (contentRect.size.width - titleW)*0.5;
    switch (self.contentHorizontalAlignment) {
        case UIControlContentHorizontalAlignmentLeft:
            switch (self.titleAliment) {
                case ButtonTitleAlimentRight:
                    titleX = hasImage?CGRectGetMaxX(imageFrame)+self.imageEdgeInsets.right + self.titleEdgeInsets.left:contentRect.origin.x + self.titleEdgeInsets.left;
                    break;
                case ButtonTitleAlimentBottom:
                case ButtonTitleAlimentLeft:
                case ButtonTitleAlimentTop:
                default:
                titleX = contentRect.origin.x + self.titleEdgeInsets.left;
                    break;
            }
            break;
        case UIControlContentHorizontalAlignmentRight:
            switch (self.titleAliment) {
                case ButtonTitleAlimentLeft:
                    titleX = hasImage?CGRectGetMinX(imageFrame)-self.titleEdgeInsets.right - self.imageEdgeInsets.left - titleW :contentRect.origin.x + (contentRect.size.width - titleW - self.titleEdgeInsets.right);
                    break;
                case ButtonTitleAlimentBottom:
                case ButtonTitleAlimentRight:
                case ButtonTitleAlimentTop:
                default:
                    titleX = contentRect.origin.x + contentRect.size.width - self.titleEdgeInsets.right - titleW;
                    break;
            }
            break;
        case UIControlContentHorizontalAlignmentFill:
            switch (self.titleAliment) {
                case ButtonTitleAlimentLeft:
                    titleX = contentRect.origin.x + self.titleEdgeInsets.left;
                    break;
                case ButtonTitleAlimentRight:
                    titleX = contentRect.origin.x + (contentRect.size.width - titleW - self.titleEdgeInsets.right);
                    break;
                case ButtonTitleAlimentBottom:
                case ButtonTitleAlimentTop:
                default:
                    titleX = titleCenterX;
                    break;
            }
            break;
        case UIControlContentHorizontalAlignmentCenter:
        default:
            switch (self.titleAliment) {
                case ButtonTitleAlimentLeft:
                    titleX = hasImage?CGRectGetMinX(imageFrame)-self.titleEdgeInsets.right - self.imageEdgeInsets.left - titleW :titleCenterX;
                    break;
                case ButtonTitleAlimentRight:
                    titleX = hasImage ? CGRectGetMaxX(imageFrame)+self.titleEdgeInsets.left + self.imageEdgeInsets.right:titleCenterX;
                    break;
                case ButtonTitleAlimentBottom:
                case ButtonTitleAlimentTop:
                default:
                    titleX = titleCenterX;
                    break;
            }
            break;
    }

    return CGRectMake(titleX, titleY, titleW, titleH);
}
- (CGFloat)titleMaxWidth{
    CGFloat maxWidth = 0.0;
    maxWidth = CGRectGetWidth(self.frame);
    if(self.imageSize.width > 0 && maxWidth > 0 && (self.titleAliment == ButtonTitleAlimentLeft || self.titleAliment == ButtonTitleAlimentRight)){
        maxWidth = maxWidth - self.imageSize.width;
        if(self.titleAliment == ButtonTitleAlimentLeft){
            maxWidth -= (self.titleEdgeInsets.right + self.imageEdgeInsets.left);
        }else{
            maxWidth -= (self.titleEdgeInsets.left + self.imageEdgeInsets.right);
        }
    }
    if(maxWidth <= 0.0){
        maxWidth = 100.0;
    }
    return maxWidth;
}

- (CGFloat)titleMaxHeight{
    CGFloat maxHeight = 0.0;
    maxHeight = CGRectGetHeight(self.frame);
    if(self.imageSize.height > 0 && maxHeight > 0 &&(self.titleAliment == ButtonTitleAlimentBottom || self.titleAliment == ButtonTitleAlimentTop)){
        maxHeight = maxHeight - self.imageSize.height;
        if(self.titleAliment == ButtonTitleAlimentBottom){
            maxHeight -= (self.titleEdgeInsets.top + self.imageEdgeInsets.bottom);
        }else{
           maxHeight -= (self.titleEdgeInsets.bottom + self.imageEdgeInsets.top);
        }
    }
    if(maxHeight <= 0.0){
        maxHeight = 50.0;
    }
    return maxHeight;
}
-(CGSize)titleSize{
    if(self.currentAttributedTitle){
        _titleSize = [self.currentAttributedTitle boundingRectWithSize:CGSizeMake( [self titleMaxWidth],[self titleMaxHeight]) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    }else if(self.currentTitle){
         _titleSize = [self.currentTitle boundingRectWithSize:CGSizeMake([self titleMaxWidth],[self titleMaxHeight]) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    }else{
        _titleSize = CGSizeZero;
    }
    return _titleSize;
}
-(CGSize)imageSize{
    return self.currentImage.size;
}

-(void)addImageViewBorder:(CGFloat)with cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor{
    self.imageView.layer.borderWidth = with;
    self.imageView.layer.borderColor = borderColor.CGColor;
    self.imageView.layer.cornerRadius = cornerRadius;
}
//-(void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state{
//    [super setAttributedTitle:title forState:state];
//    // 1.计算文字的尺寸
//    self.titleSize = [title boundingRectWithSize:CGSizeMake( [self titleMaxWidth],[self titleMaxHeight]) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//}
//-(void)setImage:(UIImage *)image forState:(UIControlState)state{
//    [super setImage:image forState:state];
//    //没有主观限制图片的尺寸的时候 默认按照图片的实际尺寸
//    if(CGSizeEqualToSize(self.imageSize, CGSizeZero))
//    self.imageSize = image.size;
//}

@end
