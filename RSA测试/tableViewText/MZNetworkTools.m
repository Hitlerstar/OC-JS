//
//  MZNetworkTools.m

#import "MZNetworkTools.h"


@implementation MZNetworkTools

+ (instancetype)sharedTools {
    
    static MZNetworkTools *tools;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        // 注意：末尾需要包含 '/'
        NSURL *baseURL = [NSURL URLWithString:@""];
        
        tools = [[self alloc] initWithBaseURL:baseURL];
        
    
        tools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        
        //    设置请求头
        /*
         Accept代表发送端（客户端）希望接受的数据类型。
         比如：Accept：text/xml;
         代表客户端希望接受的数据类型是xml类型
         
         Content-Type代表发送端（客户端|服务器）发送的实体数据的数据类型。
         比如：Content-Type：text/html;
         代表发送端发送的数据格式是html。requestSerializer
         */
       
        [tools.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [tools.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    });
    
    return tools;
}


#pragma mark -1.0 封装的网络请求方法
/// 封装的网络请求方法
///
/// @param method     get/post
/// @param URLString  路径
/// @param parameters 请求参数
/// @param finished   数据加载成功与否的回调


- (void)request:(MZRequestMethod )method URLString:(NSString *)URLString parameters:(id)parameters finished:(void (^)(id, NSError *))finished {
    
    if (method == GET) {
        
        [self GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
            NSLog(@"MZ-uploadProgress:%lld", downloadProgress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              finished(responseObject, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            finished(nil, error);

        }];
        
        
    } else {
        
        [self POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
            NSLog(@"MZ-uploadProgress:%lld", uploadProgress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            finished(responseObject, nil);

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
            
            finished(nil, error);
        }];
        
    }
}

@end
