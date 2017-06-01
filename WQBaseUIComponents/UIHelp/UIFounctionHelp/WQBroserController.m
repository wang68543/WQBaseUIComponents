//
//  BroserController.m
//  YunShouHu
//
//  Created by WangQiang on 16/3/25.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQBroserController.h"
#import "WQAPPHELP.h"
@interface WQBroserController ()<UIWebViewDelegate>
@property (strong, nonatomic)  UIWebView *webView;
@end

@implementation WQBroserController

-(UIWebView *)webView{
    if(!_webView){
        _webView = [[UIWebView alloc] init];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
    }
    return _webView;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if([request.URL.scheme compare:@"tel" options:NSCaseInsensitiveSearch] == NSOrderedSame){
        [WQAPPHELP callNumber:request.URL.resourceSpecifier];
        return NO;
    }
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if(!self.title || self.title.length <= 0){
        self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]]];
}
@end
