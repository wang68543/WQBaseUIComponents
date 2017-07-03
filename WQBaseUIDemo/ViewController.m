//
//  ViewController.m
//  WQBaseUIDemo
//
//  Created by WangQiang on 2017/5/26.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import "ViewController.h"
#import "WQEdgeTitleButton.h"

@interface ViewController ()

@end

@implementation ViewController
static NSString *const identifier = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];

    
    _titleArray = @[@"获取图片与分享UI",@"下拉框",@"按钮的图片与标题的排列",@"任意大小的星星评分",@"垂直无限滚动文字",@"textView的占位文字",@"考试题目翻页",@"日期选择",@"无限循环",@"TabBar滑动",@"日历",@"CAReplicatorLayer生成重复控件动画",@"富文本输入框",@"多个标签选择",@"抽屉式菜单",@"键盘处理",@"转场动画",@"通用tableView",@"录音播放"];
    _viewControllers = @[@"GetPictureViewController",@"DropDownViewController",@"ButtonTitleImageLayoutViewController",@"StarViewController",@"VerticalScrollTextViewController",@"TextViewPlacehodelViewController",@"GuDExamineViewController",@"DateSelectViewController",@"WQLoopViewController",@"WQTabBarViewController",@"WQClanderViewController",@"ReplicatorViewController",@"WQChatInputViewController",@"WQSelectedTagsViewController",@"WQContainerViewController",@"WQKeyboardHandleViewController",@"WQAnimationTrasitionViewController",@"WQTableViewController",@"WQVoiceViewController"];
    self.tableView.rowHeight = 60.0;
    
}


#pragma mark --
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    if(_viewControllers.count > 0)
        cell.detailTextLabel.text = _viewControllers[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *classStr =_viewControllers[indexPath.row];
    UIViewController *vc;
    if([classStr isEqualToString:@"WQTabBarViewController"]){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"TabbbarController" bundle:nil];
        vc = sb.instantiateInitialViewController;
    }else{
        vc = [[NSClassFromString(classStr) alloc] init];
    }
    
    vc.title = _titleArray[indexPath.row];
    
    //如果一个控制器是通过Xib创建的 而他的View上面又没有通过Xib创建的子控件就会造成卡黑屏 设置下背景颜色即解决(可能是有类似后缀名的XIB的文件但是没有完全符合要求的XIB控件)
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
    if([classStr isEqualToString:@"WQContainerViewController"]){
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

@end
