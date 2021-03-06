//
//  ViewController.m
//  JavaScript
//
//  Created by tianbai on 16/6/8.
//  Copyright © 2016年 厦门乙科网络公司. All rights reserved.
//

#import "ViewController.h"
#define JsStr @"var rrx = {}; (function initialize() {rrx.getUserInfo = function() { return '%@';};})();"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
-(void)viewDidAppear:(BOOL)animated{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.webView.delegate = self;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"rrx"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    
    
    //调用插入一段代码
//    NSString *str = @"'{\"name\":\"%@\",\"idno\":\"%@\",\"mobile\":\"%@\"}'";
//    
//    
//    NSString *jsStr = [NSString stringWithFormat:JsStr,str];
//    
//    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
    
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"rrx.getUserInfo() = function(){return '{\'name\':\'name\',\'idno\':\"idno\',\'mobile\':\'mobile\'}'};"];

}


- (void)call{
    NSLog(@"call");
    // 之后在回调js的方法Callback把内容传出去
    JSValue *Callback = self.jsContext[@"Callback"];
    //传值给web端
    [Callback callWithArguments:@[@"唤起本地OC回调完成"]];
}


- (void)getCall:(NSString *)callString{
    
    NSLog(@"MZ-打印OC传递给JS的参数:%@", callString);
    // 成功回调js的方法Callback
    JSValue *Callback = self.jsContext[@"Callback"];
    [Callback callWithArguments:@[@"MZ唤起本地OC回调完成"]];
    
//    直接添加提示框
//    NSString *str = @"alert('OC添加JS提示成功')";
//    [self.jsContext evaluateScript:str];

}

-(NSString *)getUserInfo
{
//    NSLog(@"MZ");
    
    return @"'{\"name\":\"%@\",\"idno\":\"%@\",\"mobile\":\"%@\"}'";

}

//-(void)getUserInfo
//{
//    [self getUserInfoMess];
//}

- (NSString *)getUserInfoMess
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"name"] = @"name";
    dict[@"idno"] = @"idno";
    dict[@"mobile"] = @"mobile";
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
