//
//  NSData+RRXDES.h
//  tableViewText
//
//  Created by 孟哲 on 2017/1/4.
//  Copyright © 2017年 孟哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (RRXDES)

/*
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
*/
+ (NSData *)DESEncrypt:(NSString *)origin_str WithKey:(NSString *)key;


/*
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
*/
+ (NSData *)DESDecrypt:(NSString *)decrypt_str WithKey:(NSString *)key;




@end
