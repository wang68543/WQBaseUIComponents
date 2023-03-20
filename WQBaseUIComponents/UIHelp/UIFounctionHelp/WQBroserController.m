//
//  BroserController.m
//  YunShouHu
//
//  Created by WangQiang on 16/3/25.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQBroserController.h"
#import "WQAPPHELP.h"
#import <WebKit/WebKit.h>
@interface WQBroserController ()<WKNavigationDelegate>
@property (strong, nonatomic)  WKWebView *webView;
@end

@implementation WQBroserController

-(WKWebView *)webView{
    if(!_webView){
        _webView = [[WKWebView alloc] init];
//        _webView.scalesPageToFit = YES;
//        _webView.delegate = self;
    }
    return _webView;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    if(self.URLString.length > 0){
      [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]]];
    }else{
        [self.webView loadHTMLString:self.htmlString baseURL:nil];
    }
    
}
@end
