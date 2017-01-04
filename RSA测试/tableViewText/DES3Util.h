//
//  DES3Util.h
//  DES
//
//  Created by Toni on 12-12-27.
//  Copyright (c) 2012年 sinofreely. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"
#import <CommonCrypto/CommonCryptor.h>

@interface DES3Util : NSObject

//加密方法
+(NSString *)encryptUseDES:(NSString *)origin_str key:(NSString *)key;
//解密方法
+(NSString *)decryptUseDES:(NSString *)cipher_str key:(NSString *)key;
@end
