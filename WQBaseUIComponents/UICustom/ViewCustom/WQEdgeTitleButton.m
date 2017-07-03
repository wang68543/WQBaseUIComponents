//
//  KDBottomTitleButton.m
//  KD_3.0
//
//  Created by WangQiang on 15/10/9.
//  Copyright © 2015年 JunJun. All rights reserved.
//

#import "WQEdgeTitleButton.h"
#import <objc/runtime.h>

@interface WQEdgeTitleButton(){
    UIFont *_labelFont;
}
@end
@implementation WQEdgeTitleButton
static char *const kLabelFontContext = "labelFont";

-(instancetype)init{
    if(self = [super init]){
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit{
    //MARK: 如果控件是代码创建的 此时titleLabel 已创建好 不存在以下问题
    //MARK: 如果控件是通过xib创建的 titleLabel 是通过懒加载方式创建的 而titleLabel 懒加载的时候又会titleRectForContentRect 来确定尺寸 所以如果在titleLabel还未懒加载完成的时候 就访问self.titleLabel 会造成死循环
//    self.contentEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    self.titleLabel.numberOfLines = 0;
    _titleAliment = ButtonTitleAlimentRight;
    
}

//TODO: contentRect不包含self.contentEdgeInsets  contentRect是frame与contentEdgeInsets的交集部分 返回的rect不包含imageEdgeInsets
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{

    if(!self.currentImage || CGRectEqualToRect(contentRect, CGRectZero)){
        return CGRectZero;
    }
    
    BOOL hasText = self.currentTitle.length > 0 ?YES:NO;
    
    CGSize imageSize = [self imageSizeWithContentRect:contentRect];
    CGFloat imageW = imageSize.width;
    CGFloat imageH = imageSize.height;
    
    CGFloat imageY = 0;
    CGFloat imageX = 0;
    CGFloat imageContentW = imageW + self.imageEdgeInsets.left + self.imageEdgeInsets.right;
    CGFloat imageContentH = imageH + self.imageEdgeInsets.top + self.imageEdgeInsets.bottom;
    
    CGSize titleSize = [self titleSizeWithContentRect:contentRect];
    //内容的单独高度
    CGFloat titleH =  titleSize.height;
    CGFloat titleW =  titleSize.width;
    
    CGFloat titleContentH =  titleH + self.titleEdgeInsets.bottom + self.titleEdgeInsets.top;
    CGFloat titleContentW =  titleW + self.titleEdgeInsets.left + self.titleEdgeInsets.right;
    if(!hasText){
        titleContentH = 0.0;
        titleContentW = 0.0;
    }
    //内容的最大宽高
    CGFloat contentMaxH = contentRect.size.height + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
    CGFloat contentMaxW = contentRect.size.width + self.contentEdgeInsets.left + self.contentEdgeInsets.right;
    
    //当title与image垂直排列的时候
    CGFloat imageCenterY = (contentMaxH - imageContentH)*0.5 - self.imageEdgeInsets.top;
 
    switch (self.contentVerticalAlignment) {//垂直
        case UIControlContentVerticalAlignmentTop:
            switch (self.titleAliment) {
                case ButtonTitleAlimentTop:
                    imageY = titleContentH+self.imageEdgeInsets.top+self.contentEdgeInsets.top;
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
                    imageY = contentMaxH - titleContentH - imageH - self.imageEdgeInsets.bottom - self.contentEdgeInsets.bottom;
                    break;
                    
                case ButtonTitleAlimentTop:
                case ButtonTitleAlimentLeft:
                case ButtonTitleAlimentRight:
                default:
                    imageY = contentMaxH - imageH - self.imageEdgeInsets.bottom - self.contentEdgeInsets.bottom;
                    break;
            }
            break;
        
          //TODO:--  如果图片与文字同时存在且竖直排列则按照上下边距(contentEdgeInsets + 各自的EdgeInsets)排列 否则就y轴居中
        case UIControlContentVerticalAlignmentFill:
            switch (self.titleAliment) {
                case ButtonTitleAlimentTop:
                    imageY = hasText ? contentMaxH - self.contentEdgeInsets.bottom - imageContentH + self.imageEdgeInsets.top :imageCenterY;
                    break;
                    
                case ButtonTitleAlimentBottom:
                    imageY = hasText ? self.imageEdgeInsets.top + self.contentEdgeInsets.top :imageCenterY;
                    break;
                case ButtonTitleAlimentLeft:
                case ButtonTitleAlimentRight:
                default:
                    imageY = imageCenterY;
                    break;
            }
            break;
            //TODO:-- 
        case UIControlContentVerticalAlignmentCenter:
        default:
            switch (self.titleAliment) {
                case ButtonTitleAlimentTop:
                    imageY = hasText?contentMaxH -  (contentMaxH - titleContentH - imageContentH)*0.5 - imageContentH + self.imageEdgeInsets.top:imageCenterY;
                    break;
                    
                case ButtonTitleAlimentBottom:
                    imageY = hasText? (contentMaxH - titleContentH - imageContentH)*0.5 + self.imageEdgeInsets.top:imageCenterY;
                    break;
                case ButtonTitleAlimentLeft:
                case ButtonTitleAlimentRight:
                default:
                    imageY = imageCenterY;;
                    break;
            }
            break;
    }

    
    //当title与image并排排列的时候
    CGFloat imageCenterX = (contentMaxW - imageContentW)*0.5 + self.imageEdgeInsets.left;
    switch (self.contentHorizontalAlignment) {
        case UIControlContentHorizontalAlignmentLeft:
            switch (self.titleAliment) {
                case ButtonTitleAlimentLeft:
                    imageX = self.contentEdgeInsets.left + titleContentW + self.imageEdgeInsets.left;
                    break;
                case ButtonTitleAlimentBottom:
                case ButtonTitleAlimentRight:
                case ButtonTitleAlimentTop:
                default:
                    imageX = self.imageEdgeInsets.left + self.contentEdgeInsets.left;
                    break;
            }
            break;
        case UIControlContentHorizontalAlignmentRight:
            switch (self.titleAliment) {
                case ButtonTitleAlimentRight:
                    imageX = contentMaxW - titleContentW -imageContentW + self.imageEdgeInsets.left - self.contentEdgeInsets.right;
                    break;
                case ButtonTitleAlimentBottom:
                case ButtonTitleAlimentLeft:
                case ButtonTitleAlimentTop:
                default:
                    imageX = contentMaxW - imageContentW + self.imageEdgeInsets.left  - self.contentEdgeInsets.right;
                    break;
            }
            break;
         //TODO:--  如果图片与文字同时存在且并排排列则按照左右边距排列 否则就x轴居中
        case UIControlContentHorizontalAlignmentFill:
            switch (self.titleAliment) {
                case ButtonTitleAlimentLeft:
                    imageX = hasText? contentMaxW - imageContentW + self.imageEdgeInsets.left - self.contentEdgeInsets.right:imageCenterX;
                    break;
                case ButtonTitleAlimentRight:
                    imageX = hasText?  self.imageEdgeInsets.left + self.contentEdgeInsets.left:imageCenterX ;
                    break;
                case ButtonTitleAlimentBottom:
                case ButtonTitleAlimentTop:
                default:
                    imageX = imageCenterX;
                    break;
            }
            break;
        case UIControlContentHorizontalAlignmentCenter:
        default:
            switch (self.titleAliment) {
                case ButtonTitleAlimentLeft:
                    imageX = hasText?contentMaxW - (contentMaxW - imageContentW - titleContentW)*0.5 - imageContentW + self.imageEdgeInsets.right:imageCenterX;
                    break;
                case ButtonTitleAlimentRight:
                    imageX = hasText?(contentMaxW - imageContentW  - titleContentW)*0.5 + self.imageEdgeInsets.left:imageCenterX ;
                    break;
                case ButtonTitleAlimentBottom:
                case ButtonTitleAlimentTop:
                default:
                    imageX = imageCenterX;
                    break;
            }
            break;
    }

 
    return CGRectMake(imageX, imageY, imageW, imageH);
}

//TODO: contentRect 与imageRectForContentRect的contentRect是相同的 返回的rect不包含imageEdgeInsets
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    if(self.currentTitle.length <= 0 || CGRectEqualToRect(contentRect, CGRectZero)){
        return CGRectZero;
    }
    
    CGFloat titleY = 0;
    
    CGFloat titleX = 0;
    
    CGSize titleSize = [self titleSizeWithContentRect:contentRect];
    
    CGFloat titleH = titleSize.height;
    
    CGFloat titleW = titleSize.width;
    
    
    
    CGFloat titleContentH =  titleH + self.titleEdgeInsets.bottom + self.titleEdgeInsets.top;
    CGFloat titleContentW =  titleW + self.titleEdgeInsets.left + self.titleEdgeInsets.right;
   
    //内容的最大宽高
    CGFloat contentMaxH = contentRect.size.height + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
    CGFloat contentMaxW = contentRect.size.width + self.contentEdgeInsets.left + self.contentEdgeInsets.right;
    
    CGSize imageSize = [self imageSizeWithContentRect:contentRect];
    
    CGFloat imageContentW = imageSize.width + self.imageEdgeInsets.left + self.imageEdgeInsets.right;
    CGFloat imageContentH = imageSize.height + self.imageEdgeInsets.top + self.imageEdgeInsets.bottom;

    //是否有图片
    BOOL hasImage = self.currentImage?YES:NO;
    if(!hasImage){
        imageContentW = 0.0;
        imageContentH = 0.0;
    }
    //并排排列的时候
      CGFloat titleCenterY = (contentMaxH - titleContentH)*0.5 + self.titleEdgeInsets.top;

        switch (self.contentVerticalAlignment) {//垂直
            case UIControlContentVerticalAlignmentTop:
                switch (self.titleAliment) {
                    case ButtonTitleAlimentBottom:
                        titleY =self.contentEdgeInsets.top + imageContentH +self.titleEdgeInsets.top ;
                        break;
                        
                    case ButtonTitleAlimentLeft:
                    case ButtonTitleAlimentTop:
                    case ButtonTitleAlimentRight:
                    default:
                        titleY = self.titleEdgeInsets.top + self.contentEdgeInsets.top;
                        break;
                }
                break;
            case UIControlContentVerticalAlignmentBottom:
                switch (self.titleAliment) {
                    case ButtonTitleAlimentTop:
                        titleY = contentMaxH  - self.contentEdgeInsets.bottom- imageContentH -titleContentH + self.titleEdgeInsets.top;
                        break;
                        
                    case ButtonTitleAlimentBottom:
                    case ButtonTitleAlimentLeft:
                    case ButtonTitleAlimentRight:
                    default:
                        titleY = contentMaxH - self.contentEdgeInsets.bottom - titleContentH +self.titleEdgeInsets.top;
                        break;
                }
                break;
            
            case UIControlContentVerticalAlignmentFill:
                switch (self.titleAliment) {
                    case ButtonTitleAlimentTop:
                        titleY = hasImage ? self.titleEdgeInsets.top + self.contentEdgeInsets.top:titleCenterY;
                        break;
                    case ButtonTitleAlimentBottom:
                        titleY = hasImage?contentMaxH - self.contentEdgeInsets.bottom - titleContentH + self.titleEdgeInsets.top :titleCenterY;
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
                        titleY = hasImage ? (contentMaxH - titleContentH - imageContentH)*0.5 + self.titleEdgeInsets.top : titleCenterY;
                        break;
                        
                    case ButtonTitleAlimentBottom:
                        titleY = hasImage ? contentMaxH - (contentMaxH - titleContentH - imageContentH)*0.5 - titleContentH + self.titleEdgeInsets.top :titleCenterY;
                        break;
                    case ButtonTitleAlimentLeft:
                    case ButtonTitleAlimentRight:
                    default:
                        titleY = titleCenterY ;
                        break;
                }
                break;
        }
    CGFloat titleCenterX = (contentMaxW - titleContentW)*0.5 + self.titleEdgeInsets.left;
    switch (self.contentHorizontalAlignment) {
        case UIControlContentHorizontalAlignmentLeft:
            switch (self.titleAliment) {
                case ButtonTitleAlimentRight:
                    titleX = self.contentEdgeInsets.left + imageContentW + self.titleEdgeInsets.left;
                    break;
                case ButtonTitleAlimentBottom:
                case ButtonTitleAlimentLeft:
                case ButtonTitleAlimentTop:
                default:
                titleX = self.contentEdgeInsets.left + self.titleEdgeInsets.left;
                    break;
            }
            break;
        case UIControlContentHorizontalAlignmentRight:
            switch (self.titleAliment) {
                case ButtonTitleAlimentLeft:
                    titleX = contentMaxW - self.contentEdgeInsets.right - imageContentW - titleContentW+self.titleEdgeInsets.left;
                    break;
                case ButtonTitleAlimentBottom:
                case ButtonTitleAlimentRight:
                case ButtonTitleAlimentTop:
                default:
                    titleX = contentMaxW - self.contentEdgeInsets.right - titleContentW + self.titleEdgeInsets.left;
                    break;
            }
            break;
            
        case UIControlContentHorizontalAlignmentFill:
            switch (self.titleAliment) {
                case ButtonTitleAlimentLeft:
                    titleX = hasImage ?self.contentEdgeInsets.left + self.titleEdgeInsets.left:titleCenterX;
                    break;
                case ButtonTitleAlimentRight:
                    titleX = contentMaxW  - self.contentEdgeInsets.right  - titleContentW + self.titleEdgeInsets.left;
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
                    titleX = (contentMaxW - imageContentW - titleContentW)*0.5 + self.titleEdgeInsets.left ;
                    break;
                case ButtonTitleAlimentRight:
                    titleX = hasImage ?contentMaxW -  (contentMaxW - imageContentW - titleContentW)*0.5 - titleContentW + self.titleEdgeInsets.left:titleCenterX;
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
//TODO: 实时计算当前的标题的尺寸
-(CGSize)titleSizeWithContentRect:(CGRect)contentRect{
    
    CGFloat maxWidth = CGRectGetWidth(contentRect);
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
    
    CGFloat maxHeight = CGRectGetHeight(contentRect);
    if(self.imageSize.height > 0 && maxHeight > 0 &&(self.titleAliment == ButtonTitleAlimentBottom || self.titleAliment == ButtonTitleAlimentTop)){
        maxHeight = maxHeight - self.imageSize.height;
        if(self.titleAliment == ButtonTitleAlimentBottom){
            maxHeight -= (self.titleEdgeInsets.top + self.imageEdgeInsets.bottom);
        }else{
            maxHeight -= (self.titleEdgeInsets.bottom + self.imageEdgeInsets.top);
        }
    }
    if(maxHeight <= 0.0){
        maxHeight = 100.0;
    }
    
    
    CGSize maxContentSize = CGSizeMake(maxWidth, maxHeight);
    
    CGSize titleSize = CGSizeZero;
    if(self.currentAttributedTitle){
        titleSize = [self.currentAttributedTitle boundingRectWithSize:maxContentSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    }else if(self.currentTitle && _labelFont){
        titleSize = [self.currentTitle boundingRectWithSize:maxContentSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_labelFont} context:nil].size;
    }
    return titleSize;
}

//TODO: 实时计算当前的imageView的尺寸
-(CGSize)imageSizeWithContentRect:(CGRect)contentRect{
    CGSize imageSize = self.imageSize;
    if(CGSizeEqualToSize(imageSize, CGSizeZero)){
        imageSize = self.currentImage.size;
    }
    
    CGFloat imageW = imageSize.width;
    CGFloat imageH = imageSize.height;
    if(imageW > contentRect.size.width || imageH > contentRect.size.height){
        if(imageW > contentRect.size.width){
            imageH *= (contentRect.size.width/imageW);
            imageW = contentRect.size.width;
            
        }
        if(imageH > contentRect.size.height){
            imageW *= (contentRect.size.width/imageH);
            imageH = contentRect.size.height;
        }
    }

    
    return CGSizeMake(imageW, imageH);
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if(newSuperview){
        _labelFont = self.titleLabel.font;
        //用于解决xib创建titleSize里面访问self.titleLabel 造成死循环问题
        [self.titleLabel addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:kLabelFontContext];
    }else{
        [self.titleLabel removeObserver:self forKeyPath:@"font"];
    }
}

-(void)addImageViewBorder:(CGFloat)with cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor{
    self.imageView.layer.borderWidth = with;
    self.imageView.layer.borderColor = borderColor.CGColor;
    self.imageView.layer.cornerRadius = cornerRadius;
}

@end
