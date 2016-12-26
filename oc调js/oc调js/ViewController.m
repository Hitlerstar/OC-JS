//
//  ViewController.m
//  oc调js
//
//  Created by 孟哲 on 2016/12/19.
//  Copyright © 2016年 孟哲. All rights reserved.
//

#import "ViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

#define JsStr @"var rrx = {}; (function initialize() { rrx.getUserInfo = function () { return '%@';};})();"

@interface ViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *rrxWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.rrxWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    
    self.rrxWebView.backgroundColor = [UIColor greenColor];
    
    self.rrxWebView.delegate = self;
    
    [self.view addSubview:self.rrxWebView];
    
//    http://api.crawlertest.rrx360.com/h5/?rrx_token=f2a884d4-c95e-11e6-92dc-acbc32839867
    
//     NSString *path = @"http://h5.crawler.rrx360.com/?rrx_token=rrx_token";
    
    NSString *path = @"http://h5.crawler.rrx360.com/?rrx_token=rrx_token";

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
    
    self.jsContext = [self.rrxWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    self.jsContext[@"rrx"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        
        NSLog(@"异常信息：%@", exceptionValue);
        
    };

    
    [self.rrxWebView loadRequest:request];
    
    JSContext *context = [self.rrxWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    NSLog(@"MZ-context:%@",context);
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *currentURL = [self.rrxWebView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    
       NSString *jsonStr = [self getUserInfo];
    
       NSString *js = [NSString stringWithFormat:JsStr,jsonStr];
    
       [self.rrxWebView stringByEvaluatingJavaScriptFromString:js];
    
//    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    self.jsContext[@"rrx"] = self;
//    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
//        context.exception = exceptionValue;
//        
//        NSLog(@"异常信息：%@", exceptionValue);
//        
//    };

    NSLog(@"\ncurrentURL:%@\njsonStr:%@\n",currentURL,jsonStr);
    
//    NSString *str = [NSString stringWithFormat:@"$('#rrx_content').text('mengzhe，1856262，3689896658')"];
//    
//    [self.rrxWebView stringByEvaluatingJavaScriptFromString:str];
    

    
}


//- (void)getUserInfo
//{
//    NSLog(@"getUserInfo");
//    NSString *str = @"alert('OC添加JS提示成功')";
//    [self.jsContext evaluateScript:str];
//
//    [self getUserInfoMess];
//}
//

//-(NSString *)getUserInfo
//{
//    return @"'{\"name\":\"name\",\"idno\":\"dno\",\"mobile\":\"mobile\"}'";
//
//}


- (NSString *)getUserInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"name"] = @"name";
    dict[@"idno"] = @"idno";
    dict[@"mobile"] = @"mobile";
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


- (void)getCall:(NSString *)callString
{
    
    
}



@end
