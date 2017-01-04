//
//  DES3Util.m
//  DES
//
//  Created by Toni on 12-12-27.
//  Copyright (c) 2012年 sinofreely. All rights reserved.
//

#import "DES3Util.h"

@implementation DES3Util


 const Byte iv[] = {1,2,3,4,5,6,7,8};


//Des加密
 +(NSString *)encryptUseDES:(NSString *)origin_str key:(NSString *)key
 {
    
     NSString *cipher_str = nil;
     NSData *textData = [origin_str dataUsingEncoding:NSUTF8StringEncoding];
     NSUInteger dataLength = [textData length];
     unsigned char buffer[1024];
     memset(buffer, 0, sizeof(char));
     size_t numBytesEncrypted = 0;
     CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                        kCCAlgorithmDES,
                                        kCCOptionPKCS7Padding,
                                        [key UTF8String],
                                        kCCKeySizeDES,
                                        iv,
                                        [textData bytes],
                                        dataLength,
                                        buffer,
                                        2048,
                                        &numBytesEncrypted);
     
         if (cryptStatus == kCCSuccess)
           {
                 NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
                 cipher_str = [GTMBase64 stringByEncodingData:data];
           }else{
               
               NSLog(@"加密失败!");
           }
     
         return cipher_str;
     }



//Des解密
 +(NSString *)decryptUseDES:(NSString *)cipher_str key:(NSString *)key
 {
         NSString *origin_str = nil;
         NSData *cipherdata = [GTMBase64 decodeString:cipher_str];
         unsigned char buffer[1024];
         memset(buffer, 0, sizeof(char));
         size_t numBytesDecrypted = 0;
         CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                             kCCAlgorithmDES,
                                             kCCOptionPKCS7Padding,
                                             [key UTF8String],
                                             kCCKeySizeDES,
                                             iv,
                                             [cipherdata bytes],
                                             [cipherdata length],
                                             buffer,
                                             2048,
                                             &numBytesDecrypted);
         if(cryptStatus == kCCSuccess)
         {
                NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
                 origin_str = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
         }else{
             
             NSLog(@"解密失败!");
         }
     
     return origin_str;
     
     }


@end
