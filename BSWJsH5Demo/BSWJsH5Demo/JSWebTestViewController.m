//
//  JSWebTestViewController.m
//  QWSAppSchemeTest
//
//  Created by yuhanle on 16/3/11.
//  Copyright © 2016年 煜寒了. All rights reserved.
//

#import "JSWebTestViewController.h"

@interface JSWebTestViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation JSWebTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 监听可以注入js 方法的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didCreateJSContext:) name:@"DidCreateContextNotification"
                                               object:nil];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

#pragma mark - 注入js 的监听
- (void)didCreateJSContext:(NSNotification *)notification {
    NSString *indentifier = [NSString stringWithFormat:@"indentifier%lud", (unsigned long)self.webView.hash];
    NSString *indentifierJS = [NSString stringWithFormat:@"var %@ = '%@'", indentifier, indentifier];
    [self.webView stringByEvaluatingJavaScriptFromString:indentifierJS];
    
    JSContext *context = notification.object;
    
    if (![context[indentifier].toString isEqualToString:indentifier]) return;
    
    self.jsContext = context;
    // 通过模型调用方法，这种方式更好些
    QWSJsObjCModel *model  = [[QWSJsObjCModel alloc] init];
    self.jsContext[@"nativeObj"] = model;
    model.jsContext = self.jsContext;
    model.webView   = self.webView;
    model.webVc     = self;
    
    self.jsContext[@"getUserinfo"] = ^(){
        return @"1234";
    };
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

#pragma mark - Private Method
- (IBAction)dayin:(id)sender {
    NSString *shareUrl = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName(\"shareUrl\")[0].content"];
    NSLog(@"shareUrl = %@", shareUrl);
    
    [self.webView reload];
}

#pragma mark - Life Cycle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation NSObject (JSTest)

- (void)webView:(id)unuse didCreateJavaScriptContext:(JSContext *)ctx forFrame:(id)frame {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidCreateContextNotification" object:ctx];
}

@end
