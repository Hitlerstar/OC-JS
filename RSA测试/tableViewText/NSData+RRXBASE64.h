//
//  NSData+RRXBASE64.h
//  tableViewText
//
//  Created by 孟哲 on 2017/1/4.
//  Copyright © 2017年 孟哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (RRXBASE64)

/*
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 */
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

/*
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 */
+ (NSString *)base64EncodedStringFrom:(NSData *)data;



+ (NSString *)base64Encode:(NSData *)data;

+ (NSData *)base64Decode:(NSString *)string;



@end
