//
//  JSWebTestViewController.h
//  QWSAppSchemeTest
//
//  Created by yuhanle on 16/3/11.
//  Copyright © 2016年 煜寒了. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class JSWebTestViewController;
@protocol JavaScriptObjectiveCDelegate <JSExport>

// JS调用此方法来调用OC的系统相册方法
- (void)callSystemCamera;
// 在JS中调用时，函数名应该为showAlertMsg(arg1, arg2)
// 这里是只两个参数的。
- (void)showAlert:(NSString *)title msg:(NSString *)msg;
// 通过JSON传过来
- (void)callWithDict:(NSDictionary *)params;
// JS调用Oc，然后在OC中通过调用JS方法来传值给JS。
- (void)jsCallObjcAndObjcCallJsWithDict:(NSDictionary *)params;

- (NSString *)getUserinfo;

- (NSString *)getToken:(NSString *)qwsKey;

/**
 *  H5 传递key 获取newToken 在调用其 callback 方法
 *
 *  @param key      qwskey
 *  @param callback 回调方法名
 *  @param property 方法参数
 */
- (void)getNewToken:(NSString *)key callback:(NSString *)callback property:(NSString *)property;

@end

// 此模型用于注入JS的模型，这样就可以通过模型来调用方法。
@interface QWSJsObjCModel : NSObject <JavaScriptObjectiveCDelegate>

@property (nonatomic, weak) JSContext *jsContext;
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, weak) JSWebTestViewController *webVc;

@end

@implementation QWSJsObjCModel

- (void)callWithDict:(NSDictionary *)params {
    NSLog(@"Js调用了OC的方法，参数为：%@", params);
}

// Js调用了callSystemCamera
- (void)callSystemCamera {
    NSLog(@"JS调用了OC的方法，调起系统相册");
    
    // JS调用后OC后，又通过OC调用JS，但是这个是没有传参数的
    JSValue *jsFunc = self.jsContext[@"jsFunc"];
    
    [self thint:^(bool isOk) {
        if (isOk) {
            [jsFunc callWithArguments:@[@"1234"]];
        }
    }];
}

- (void)thint:(void(^)(bool isOk))block {
    
    [self thint2:^(bool isOk) {
        if (isOk) {
            if (block) {
                block(isOk);
            }
        }
    }];
}

- (void)thint2:(void(^)(bool isOk))block {
    /*
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://httpbin.org/get" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            block(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
     */
    
}

- (void)jsCallObjcAndObjcCallJsWithDict:(NSDictionary *)params {
    NSLog(@"jsCallObjcAndObjcCallJsWithDict was called, params is %@", params);
    
    // 调用JS的方法
    JSValue *jsParamFunc = self.jsContext[@"jsParamFunc"];
    [jsParamFunc callWithArguments:@[@{@"age": @10, @"name": @"lili", @"height": @158}]];
}

- (void)showAlert:(NSString *)title msg:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil, nil];
        [a show];
    });
}

- (NSString *)getUserinfo {
    return @"1234";
}



- (NSString *)getToken:(NSString *)qwsKey {
    NSLog(@"1234");
    return @"1234";
}

- (void)getNewToken:(NSString *)key callback:(NSString *)callback property:(NSString *)property {
    __block NSString * newToken = @"1234";
    __block NSInteger result = 0;
    result = 1 ? 0 : 1;
    
    /* 方案 1 不可行
    JSValue * successHandler = self.jsContext[callback];
    JSManagedValue * managedHandler = [JSManagedValue managedValueWithValue:successHandler];
    [self.jsContext.virtualMachine addManagedReference:managedHandler withOwner:self];
    
    [self thint:^(bool isOk) {
        if (isOk) {
            [[managedHandler value] callWithArguments:@[@(result), newToken, property]];
            [[JSContext currentContext].virtualMachine removeManagedReference:managedHandler
                                                                    withOwner:self];
        }
    }];
     */
    
    
    // 方案 2 可行  使用NSThread
    /*
    NSThread * webThread = [NSThread currentThread];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://httpbin.org/get" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 拼接参数 默认第一个 参数为 js的调用方法 完成请求后 到主线程继续执行
        [self performSelector:@selector(callQWSJSWithArgument:) onThread:webThread withObject:@[callback, @(result), newToken, property] waitUntilDone:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
     */
    
}

- (void)callQWSJSWithArgument:(NSArray *)argument {
    NSString * callback = argument[0];
    
    JSValue * function = self.jsContext[callback];
    
    NSMutableArray * params = [NSMutableArray arrayWithArray:argument];
    // 移除第一个 方法名
    [params removeObjectAtIndex:0];
    
    [function callWithArguments:params];
}

@end

@interface JSWebTestViewController : UIViewController

@end
