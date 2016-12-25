//
//  ViewController.h
//  oc调js
//
//  Created by 孟哲 on 2016/12/19.
//  Copyright © 2016年 孟哲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>
//- (void)getUserInfo;
- (void)getCall:(NSString *)callString;

- (NSString *)getUserInfo;
@end

@interface ViewController : UIViewController<JSObjcDelegate>
@property (nonatomic, strong) JSContext *jsContext;



@end

