//
//  WQCommonBaseCell.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/13.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQCommonBaseCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface WQCommonBaseCell()
@property (strong ,nonatomic) UILabel *subtitleLabel;
@property (strong ,nonatomic) UISwitch *switchOptions;
@property (strong ,nonatomic) UILabel *bageView;
@property (strong ,nonatomic) UILabel *titleLbale;
@property (strong ,nonatomic) UIImageView *iconView;


//@property (strong ,nonatomic) UIImageView *arrowView;

@end
@implementation WQCommonBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self commonInit];
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.layer.drawsAsynchronously = YES;
    }
    return self;
}
-(void)commonInit{
    _iconView = [[UIImageView alloc] init];
//    _iconView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_iconView];
    
    _titleLbale = [[UILabel alloc] init];
    _titleLbale.font = [UIFont systemFontOfSize:17.0];
    _titleLbale.textColor = [UIColor lightGrayColor];
    _titleLbale.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.titleLbale];
    
    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.font = [UIFont systemFontOfSize:15.0];
    _subtitleLabel.numberOfLines = 0;
    _subtitleLabel.textColor = [UIColor lightGrayColor];
    _subtitleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.subtitleLabel];
    
    _bageView = [[UILabel alloc] init];
    _bageView.backgroundColor = [UIColor redColor];
    _bageView.textColor = [UIColor whiteColor];
    _bageView.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:self.bageView];
    
    _switchOptions = [[UISwitch alloc] init];
    [_switchOptions addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.switchOptions];
    
    self.selectedBackgroundView = [[UIView alloc] init];
    
    
}
-(void)switchAction:(UISwitch *)sender{
    WQCommonSwitchItem *switchItem = (WQCommonSwitchItem *)self.baseItem;
    switchItem.switchOn = !switchItem.isSwitchOn;
    if(self.baseItem.operation){
        self.baseItem.operation();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)resetContent{
    _subtitleLabel.text = nil;
    _bageView.text = nil;
   _titleLbale.text = nil;
    _iconView.image = nil;
}
-(void)setBaseItem:(WQCommonBaseItem *)baseItem{
    _baseItem = baseItem;
    [self resetContent];
    NSString *bageText = @"";
    NSString *subtitle = @"";
    UIColor *textLbaleBackcolor = [UIColor clearColor];
    UIColor *textColor = [UIColor blackColor];
    NSTextAlignment textAliment = NSTextAlignmentLeft;
    BOOL isHiddenSwitchOptions = YES;
    
    
    UITableViewCellAccessoryType accessoryType  = UITableViewCellAccessoryNone;
    UIView *accessoryView = nil;
    
    
    CGFloat leftPadding = 15.0;
    CGFloat sectionH = 8.0;
    
    CGFloat topPading = 5.0;
    CGFloat cellHeight = baseItem.cellHeight;
    
    CGFloat titleLabelRadius = 0.0;
    self.contentView.backgroundColor = baseItem.backgroundColor;
    if(cellHeight <= 0){
        cellHeight = CGRectGetHeight(self.frame);
    }
    UIFont *titleFont = baseItem.titleFont;
    if(!titleFont){
        titleFont = [UIFont systemFontOfSize:17.0];
    }
     MASViewAttribute *leftMaxXAttribute = self.contentView.mas_left ;
     CGFloat firstIconPadding = leftPadding;
    
    __weak typeof(self) weakSelf = self;
    if(baseItem.iconURL || baseItem.icon){
        CGFloat imageW = baseItem.iconSize.width;
        CGFloat imageH = baseItem.iconSize.height;
        
        UIImage *iconImage = [UIImage imageNamed:baseItem.icon];
        
        if(baseItem.iconURL){
            NSAssert(!CGSizeEqualToSize(baseItem.iconSize, CGSizeZero), @"加载网络图片的时候必须设置iconSize属性");
    
            [_iconView sd_setImageWithURL:baseItem.iconURL placeholderImage:iconImage];
        }else{
           _iconView.image = iconImage;
            if(CGSizeEqualToSize(baseItem.iconSize, CGSizeZero)){
                imageH = MIN(cellHeight - topPading*2, _iconView.image.size.height);
                imageW = _iconView.image.size.width;
            }
        }
        [_iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.contentView);
            make.left.equalTo(leftMaxXAttribute).with.offset(leftPadding);
            make.width.mas_equalTo(imageW);
            make.height.mas_equalTo(imageH);
        }];
        leftMaxXAttribute = _iconView.mas_right;
        firstIconPadding  = sectionH;
    }
    
    self.titleLbale.font = titleFont;
    
   
    MASViewAttribute *rightMinXAttribute = self.contentView.mas_right ;
    
    switch (baseItem.itemType) {
        case CommonItemTypeArrow:
    
        {
            WQCommonArrowItem *arrowItem = (WQCommonArrowItem *)baseItem;
            accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            
          
            CGFloat bageW = 0.0;
            
            if(arrowItem.bageValue == NSNotFound){
                bageW = 3.0;
            }else if(arrowItem.bageValue > 10){
                bageW = 30.0;
                if(arrowItem.bageValue <= 99){
                    bageText = [NSString stringWithFormat:@"%ld",(long)arrowItem.bageValue];
                }else{
                    bageText = @"99+";
                }
            }else if(arrowItem.bageValue > 0){
                bageW = 20.0;
                bageText = [NSString stringWithFormat:@"%ld",(long)arrowItem.bageValue];
            }
            if(bageW > 0){
                [self.bageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(weakSelf.contentView);
                    make.right.equalTo(weakSelf.contentView.mas_right);
                    make.height.and.width.mas_equalTo(bageW);
                }];
                rightMinXAttribute = self.bageView.mas_right;
                
                self.bageView.layer.cornerRadius = bageW*0.5;
                self.bageView.layer.masksToBounds = YES;
                
                self.bageView.hidden = NO;
                
            }else{
                self.bageView.hidden = YES;
            }
            
            [self.titleLbale mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.contentView.mas_top);
                make.bottom.equalTo(weakSelf.contentView.mas_bottom);
                make.left.equalTo(leftMaxXAttribute).with.offset(firstIconPadding);
                make.right.equalTo(rightMinXAttribute).with.offset(-sectionH);
            }];
        }
            break;
        case CommonItemTypeSubtitle:
        {
            
            
            WQCommonSubtitleItem *subtitleItem = (WQCommonSubtitleItem *)baseItem;
            UIFont *subTitleFont = subtitleItem.subTitleFont;
            if(!subTitleFont){
                subTitleFont = [UIFont systemFontOfSize:15.0];
            }
         
            subtitle = subtitleItem.subtitle;
            
            if(subtitleItem.needArrow){
                
                accessoryType = UITableViewCellAccessoryDisclosureIndicator;
          
                CGFloat bageW = 0.0;
                
                if(subtitleItem.bageValue == NSNotFound){
                    bageW = 3.0;
                }else if(subtitleItem.bageValue > 10){
                    bageW = 30.0;
                    if(subtitleItem.bageValue <= 99){
                        bageText = [NSString stringWithFormat:@"%ld",(long)subtitleItem.bageValue];
                    }else{
                        bageText = @"99+";
                    }
                }else if(subtitleItem.bageValue > 0){
                    bageW = 20.0;
                    bageText = [NSString stringWithFormat:@"%ld",(long)subtitleItem.bageValue];
                }
                if(bageW > 0){
                    [self.bageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(weakSelf.contentView);
                        make.right.equalTo(weakSelf.contentView.mas_right);
                        make.height.and.width.mas_equalTo(bageW);
                    }];
                    rightMinXAttribute = self.bageView.mas_right;
                    
                    self.bageView.layer.cornerRadius = bageW*0.5;
                    self.bageView.layer.masksToBounds = YES;
                    
                    self.bageView.hidden = NO;
                    
                }else{
                    self.bageView.hidden = YES;
                }
            }else{
                 self.bageView.hidden = YES;
            }
            
            switch (subtitleItem.subtitleAlignment) {
                case SubtitleAlignmentRightCenter:
                {
                    [self.titleLbale mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(weakSelf.contentView.mas_top);
                        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
                        make.left.equalTo(leftMaxXAttribute).with.offset(firstIconPadding);
                        make.width.mas_equalTo(CGRectGetWidth(weakSelf.contentView.frame)*0.4);
                    }];
                    [self.subtitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(weakSelf.contentView.mas_top);
                        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
                        make.right.equalTo(rightMinXAttribute).with.offset(-sectionH);
                        make.left.equalTo(weakSelf.titleLbale.mas_right);
                    }];
                    _subtitleLabel.textAlignment = NSTextAlignmentRight;
                }
                    break;
                case SubtitleAlignmentLeftBottom:
                {
                    [self.titleLbale mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(weakSelf.contentView.mas_top);
                        make.left.equalTo(leftMaxXAttribute).with.offset(firstIconPadding);
                        make.right.equalTo(rightMinXAttribute).with.offset(-sectionH);
                        make.height.mas_equalTo(CGRectGetHeight(weakSelf.contentView.frame)*0.6);
                    }];
                    [self.subtitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(weakSelf.titleLbale.mas_bottom);
                        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
                        make.right.equalTo(weakSelf.titleLbale.mas_right);
                        make.left.equalTo(weakSelf.titleLbale.mas_left);
                    }];
                    _subtitleLabel.textAlignment = NSTextAlignmentLeft;
                }
                    break;
                default:
                    break;
            }
            subtitle = subtitleItem.subtitle;
            self.subtitleLabel.font = subTitleFont;
        }
            break;
        case CommonItemTypeCenter:
        {
            WQCommonCenterItem *centerItem = (WQCommonCenterItem *)baseItem;
            [self.titleLbale mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(weakSelf.contentView).with.insets(centerItem.contentEdge);
            }];
            
            textAliment = NSTextAlignmentCenter;
            textLbaleBackcolor = centerItem.centerBackColor;
            textColor = centerItem.centerContentColor;
            titleLabelRadius = centerItem.cornerRadius;
        }
            break;
        case CommonItemTypeSwitch:
        {
            
            WQCommonSwitchItem *switchItem = (WQCommonSwitchItem *)baseItem;
            
            [self.titleLbale mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.contentView.mas_top);
                make.bottom.equalTo(weakSelf.contentView.mas_bottom);
                make.left.equalTo(leftMaxXAttribute).with.offset(firstIconPadding);
                make.right.equalTo(rightMinXAttribute).with.offset(-sectionH);
            }];
            accessoryView = _switchOptions;
            isHiddenSwitchOptions = NO;
            _switchOptions.on = switchItem.isSwitchOn;
            _switchOptions.enabled = switchItem.switchEnabled;
        }
            break;
        case CommonItemTypeBase:
        default:
            [self.titleLbale mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.contentView.mas_top);
                make.bottom.equalTo(weakSelf.contentView.mas_bottom);
                make.left.equalTo(leftMaxXAttribute).with.offset(firstIconPadding);
                make.right.equalTo(rightMinXAttribute).with.offset(-sectionH);
            }];
            break;
    }
    
    
    
    
    _titleLbale.text = baseItem.title;
    _titleLbale.textColor = textColor;
    _titleLbale.backgroundColor = textLbaleBackcolor;
    _titleLbale.textAlignment = textAliment;
    
    if(titleLabelRadius > 0.0){
        _titleLbale.layer.cornerRadius = titleLabelRadius;
        _titleLbale.layer.masksToBounds = YES;
    }else{
        _titleLbale.layer.cornerRadius = 0.0;
        _titleLbale.layer.masksToBounds = NO;
    }
    
    _subtitleLabel.text = subtitle;
    
    
    _bageView.text = bageText;
    
    
    self.accessoryType = accessoryType;
    self.accessoryView = accessoryView;
    
    _switchOptions.hidden = isHiddenSwitchOptions;
    
    if(baseItem.selectBackgroundColor){
        self.selectedBackgroundView.backgroundColor = baseItem.selectBackgroundColor;
    }else{
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    }
//    [self updateConstraints];
    [self setNeedsLayout];
    
}
//-(void)setBaseItem:(WQCommonBaseItem *)baseItem{
//    _baseItem = baseItem;
//    
//    NSString *bageText = @"";
//    NSString *subtitle = @"";
//    UIColor *textLbaleBackcolor = [UIColor redColor];
//    UIColor *textColor = [UIColor blackColor];
//    NSTextAlignment textAliment = NSTextAlignmentLeft;
//    BOOL isHiddenSwitchOptions = YES;
//    
//    CGRect imageViewFrame = CGRectZero;
//    
//    CGRect textLabelFrame = CGRectZero;
//    CGRect subtitleFrame = CGRectZero;
////    CGRect switchFrame = CGRectZero;
//    CGRect bageViewFrame = CGRectZero;
//    UITableViewCellAccessoryType accessoryType  = UITableViewCellAccessoryNone;
//    UIView *accessoryView = nil;
//    
//    
//    CGFloat leftPadding = 15;
//    CGFloat sectionH = 10.0;
//    
//    CGFloat maxX = leftPadding;
//    CGFloat topPading = 5.0;
//    CGFloat cellHeight = baseItem.cellHeight;
//    CGFloat cellWidth = CGRectGetWidth(self.frame);
//    
//    CGFloat titleLabelRadius = 0.0;
//    self.backgroundColor = baseItem.backgroundColor;
//    CGFloat arrowRight = 35;//箭头视图的总宽度是35
//    if(cellHeight <= 0){
//        cellHeight = CGRectGetHeight(self.frame);
//    }
//    UIFont *titleFont = baseItem.titleFont;
//    if(!titleFont){
//        titleFont = [UIFont systemFontOfSize:17.0];
//    }
//    if(baseItem.icon){
//        CGFloat imageH = cellHeight - topPading*2;
//        imageViewFrame = CGRectMake(maxX, topPading, imageH, imageH);
//        maxX +=(imageH + sectionH);
//        _iconView.image = [UIImage imageNamed:baseItem.icon];
//    }
//   CGFloat textWidth =  [baseItem.title boundingRectWithSize:CGSizeMake(cellWidth - maxX - arrowRight , cellHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleFont} context:nil].size.width;
// 
//    self.titleLbale.font = titleFont;
//    
//    switch (baseItem.itemType) {
//        case CommonItemTypeArrow:
//        {
//            WQCommonArrowItem *arrowItem = (WQCommonArrowItem *)baseItem;
//            accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            textLabelFrame = CGRectMake(maxX, 0, textWidth, cellHeight);
//            CGFloat bageW = 0.0;
//            CGFloat arroW = arrowRight;
//            if(arrowItem.bageValue == NSNotFound){
//                bageW = 3.0;
//            }else if(arrowItem.bageValue > 10){
//                bageW = 30.0;
//                if(arrowItem.bageValue <= 99){
//                    bageText = [NSString stringWithFormat:@"%ld",(long)arrowItem.bageValue];
//                }else{
//                   bageText = @"99+";
//                }
//            }else if(arrowItem.bageValue > 0){
//                bageW = 20.0;
//                bageText = [NSString stringWithFormat:@"%ld",(long)arrowItem.bageValue];
//            }
//            bageViewFrame = CGRectMake(cellWidth - arroW - bageW, (cellHeight - bageW)*0.5, bageW, bageW);
//            self.bageView.layer.cornerRadius = bageW*0.5;
//            self.bageView.layer.masksToBounds = YES;
//
//        }
//            break;
//        case CommonItemTypeSubtitle:
//        {
//            
//            
//            WQCommonSubtitleItem *subtitleItem = (WQCommonSubtitleItem *)baseItem;
//            UIFont *subTitleFont = subtitleItem.subTitleFont;
//            if(!subTitleFont){
//                subTitleFont = [UIFont systemFontOfSize:15.0];
//            }
//            CGFloat bageW = 0.0;
//            CGFloat rightMinX = cellWidth - leftPadding;
//            if(subtitleItem.needArrow){
//              accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                rightMinX = cellWidth - arrowRight;
//            }
//            if(subtitleItem.bageValue == NSNotFound){
//                bageW = 3.0;
//            }else if(subtitleItem.bageValue > 10){
//                bageW = 30.0;
//                if(subtitleItem.bageValue <= 99){
//                    bageText = [NSString stringWithFormat:@"%ld",(long)subtitleItem.bageValue];
//                }else{
//                    bageText = @"99+";
//                }
//            }else if(subtitleItem.bageValue > 0){
//                bageW = 20.0;
//                bageText = [NSString stringWithFormat:@"%ld",(long)subtitleItem.bageValue];
//            }
//            bageViewFrame = CGRectMake(rightMinX - bageW, (cellHeight - bageW)*0.5, bageW, bageW);
//            self.bageView.layer.cornerRadius = bageW*0.5;
//            self.bageView.layer.masksToBounds = YES;
//            if(bageW > 0){
//                rightMinX -= (bageW+sectionH);
//            }
//            
//            switch (subtitleItem.subtitleAlignment) {
//                case SubtitleAlignmentRightCenter:
//                    textLabelFrame = CGRectMake(maxX, 0, textWidth, cellHeight);
//                    subtitleFrame = CGRectMake(CGRectGetMaxX(textLabelFrame)+sectionH, 0, rightMinX - (CGRectGetMaxX(textLabelFrame)+sectionH), cellHeight);
//                    _subtitleLabel.textAlignment = NSTextAlignmentRight;
//                    break;
//                case SubtitleAlignmentLeftBottom:
//                    textLabelFrame = CGRectMake(maxX, 0, textWidth, cellHeight *0.6);
//                    subtitleFrame = CGRectMake(maxX, CGRectGetMaxY(textLabelFrame), rightMinX - maxX - sectionH, cellHeight*0.4);
//                    _subtitleLabel.textAlignment = NSTextAlignmentLeft;
//                    break;
//                default:
//                    break;
//            }
//            subtitle = subtitleItem.subtitle;
//            self.subtitleLabel.font = subTitleFont;
//        }
//            break;
//        case CommonItemTypeCenter:
//        {
//            WQCommonCenterItem *centerItem = (WQCommonCenterItem *)baseItem;
//            textLabelFrame = CGRectMake(centerItem.contentEdge.left, centerItem.contentEdge.top, cellWidth - centerItem.contentEdge.left - centerItem.contentEdge.right, cellHeight- centerItem.contentEdge.top - centerItem.contentEdge.bottom);
//            textAliment = NSTextAlignmentCenter;
//            textLbaleBackcolor = centerItem.centerBackColor;
//            textColor = centerItem.centerContentColor;
//            titleLabelRadius = centerItem.cornerRadius;
//        }
//            break;
//        case CommonItemTypeSwitch:
//        {
//            textLabelFrame = CGRectMake(maxX, 0, textWidth, cellHeight);
//            accessoryView = _switchOptions;
//            isHiddenSwitchOptions = NO;
//        }
//            break;
//            
//        case CommonItemTypeBase:
//            textLabelFrame = CGRectMake(maxX, 0, textWidth, cellHeight);
//        default:
//            break;
//    }
//   
//    
//    
//    _iconView.frame = imageViewFrame;
// 
//    _titleLbale.text = baseItem.title;
//    _titleLbale.textColor = textColor;
//    _titleLbale.backgroundColor = textLbaleBackcolor;
//    _titleLbale.textAlignment = textAliment;
//    _titleLbale.frame = textLabelFrame;
//    if(titleLabelRadius > 0.0){
//        _titleLbale.layer.cornerRadius = titleLabelRadius;
//        _titleLbale.layer.masksToBounds = YES;
//    }else{
//        _titleLbale.layer.cornerRadius = 0.0;
//        _titleLbale.layer.masksToBounds = NO;
//    }
//    
//    _subtitleLabel.frame = subtitleFrame;
//    _subtitleLabel.text = subtitle;
//    
//    
//    _bageView.text = bageText;
//    _bageView.frame = bageViewFrame;
//    
//    self.accessoryType = accessoryType;
//    self.accessoryView = accessoryView;
//    
//    _switchOptions.hidden = isHiddenSwitchOptions;
//    
//    if(baseItem.selectBackgroundColor){
//        self.selectedBackgroundView.backgroundColor = baseItem.selectBackgroundColor;
//    }else{
//        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
//    }
//    [self layoutIfNeeded];
//
//}
@end
