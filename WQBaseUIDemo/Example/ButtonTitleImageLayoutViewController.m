//
//  UIButtonTitleImageLayoutViewController.m
//  SomeUIKit
//
//  Created by WangQiang on 2016/10/20.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "ButtonTitleImageLayoutViewController.h"
#import "WQEdgeTitleButton.h"

@interface ButtonTitleImageLayoutViewController ()

@end

@implementation ButtonTitleImageLayoutViewController
-(void)loadView{
    UIScrollView *sv = [[UIScrollView alloc] init];
    
    self.view = sv;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"还挺会\n海上生活听月星" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName :[UIColor blueColor],NSParagraphStyleAttributeName:paraStyle}];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[@"还挺会\n海上生活听月星" rangeOfString:@"海上生活听月星"]];
    
    
    
    CGSize normalSize = CGSizeMake(100, 80);
    
//    WQEdgeTitleButton *leftTilte = [self commonContentTitle];
//  
//    leftTilte.titleAliment = ButtonTitleAlimentLeft;
//    leftTilte.frame = CGRectMake(20, 80, normalSize.width, normalSize.height);
//    
//    WQEdgeTitleButton *bottomTilte = [self commonContentTitle];
//    bottomTilte.titleAliment = ButtonTitleAlimentBottom;
//    bottomTilte.frame = CGRectMake(160, 80, normalSize.width, normalSize.height);
    
    WQEdgeTitleButton *topTilte = [self commonContentTitle];
    topTilte.titleAliment = ButtonTitleAlimentRight;
    topTilte.titleEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 28);
    topTilte.frame = CGRectMake(20, 200, 200, 120);
    [topTilte setAttributedTitle:str forState:UIControlStateNormal];
    
//    
    WQEdgeTitleButton *leftContent = [self commonContentTitle];
    
    leftContent.titleAliment = ButtonTitleAlimentLeft;
    leftContent.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [leftContent setAttributedTitle:str forState:UIControlStateNormal];
    leftContent.frame = CGRectMake(20, CGRectGetMaxY(topTilte.frame)+10.0, 280 , 120);
    leftContent.imageSize = CGSizeMake(80, 80);
//
    WQEdgeTitleButton *RightContent = [self commonContentTitle];
    RightContent.titleAliment = ButtonTitleAlimentBottom;
    RightContent.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    RightContent.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    RightContent.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    RightContent.frame = CGRectMake(20, CGRectGetMaxY(leftContent.frame)+10.0, 280 , 120);
//
//    [self.view setValue:[NSValue valueWithCGSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, CGRectGetMaxY(RightContent.frame) + 20)] forKeyPath:@"contentSize"];
}

-(WQEdgeTitleButton *)commonContentTitle{
    WQEdgeTitleButton *edgeBtn = [[WQEdgeTitleButton  alloc] init];
    [edgeBtn setTitle:@"标题" forState:UIControlStateNormal];
    [edgeBtn setImage:[UIImage imageNamed:@"loud_speaker"] forState:UIControlStateNormal];
    
    [edgeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    edgeBtn.backgroundColor = [UIColor greenColor];
    edgeBtn.titleLabel.backgroundColor = [UIColor grayColor];
    [self.view addSubview:edgeBtn];
    return edgeBtn;
}
@end
