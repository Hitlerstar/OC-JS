//
//  MainViewController.m
//  StateJS
//
//  Created by 王会洲 on 16/8/24.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#import "MainViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface MainViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webView;
@end

@implementation MainViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MZ-OC调用JS传值";
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.webView.delegate = self;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];

    
    //demo
    JSContext * context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    /**js调用oc*/
    context[@"sendTextStr"] = ^(){
        NSLog(@"js调用");
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
    };
    
    
    context[@"didViewLoad"] = ^(){
        NSLog(@"js调用--ViewdidLoad");
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
    };
    
    /**oc给js传入函数值*/
    NSString * func = [NSString stringWithFormat:@"show('%@');",@"OC后台传入数据"];
    [self.webView stringByEvaluatingJavaScriptFromString:func];

    
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}

@end
