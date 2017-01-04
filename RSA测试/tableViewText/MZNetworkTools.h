//
//  MZNetworkTools.h

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

/// 网络请求枚举
typedef enum : NSUInteger {
    GET = 0,
    POST,
    HEADER
} MZRequestMethod;

@interface MZNetworkTools : AFHTTPSessionManager

+ (instancetype)sharedTools;

- (void)request:(MZRequestMethod)method URLString:(NSString *)URLString parameters:(id)parameters finished:(void (^)(id result, NSError *error))finished;

@end
