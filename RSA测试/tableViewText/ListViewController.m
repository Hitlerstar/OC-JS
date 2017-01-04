//
//  ListViewController.m
//  tableViewText
//
//  Created by 孟哲 on 2017/1/2.
//  Copyright © 2017年 孟哲. All rights reserved.
//


#import "ListViewController.h"
#import "MZNetworkTools.h"


#import "NSData+KKRSA.h"
#import "NSData+RRXDES.h"
#import "NSData+RRXBASE64.h"
#import "DES3Util.h"
#import "NSData+KKAES.h"
#import "GTMBase64.h"

#define kRSA_KEY_SIZE 2048

@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)NSMutableArray *listArray;

@property(assign,nonatomic)BOOL isFirstInVc;

//@property(assign,nonatomic)SecKeyRef publicKeyRef;
//
//@property(assign,nonatomic)SecKeyRef privateKeyRef;

@end

@implementation ListViewController

-(NSMutableArray *)listArray
{
    if (_listArray == nil) {
        
        _listArray = [[NSMutableArray alloc]init];
    }
    
    return _listArray;
}

-(void)viewDidAppear:(BOOL)animated
{
    
    if (self.isFirstInVc == NO) {
        
        [self.listArray removeAllObjects];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self getRrxUserListBook];
            
        });
        
    }
    
    self.isFirstInVc = NO;
    
    NSLog(@"2-----self.isFirstInVc:%d",self.isFirstInVc);
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];

//    [self setupRefresh];
//    [self loadListUserInfo];
    
    self.isFirstInVc = YES;
    
    [self generateRSAKeyPair:kRSA_KEY_SIZE];
    
//    公钥加密私钥密钥测试
//    [self testRSAEncryptAndDecrypt];

    [self DESEncrypt];
    
//    [self AESEncrypt];
    
    [self base64data];
}



#pragma mark 加密测试

//4、
-(void)base64data
{
  const Byte iv[] = {1,2,3,4,5,6,7,8};
    
    NSData *adata = [[NSData alloc] initWithBytes:iv length:8];
    
   NSString *cipher_str = [GTMBase64 stringByEncodingData:adata];
    
    NSLog(@"mz-cipher_str:%@",cipher_str);

    
}


//3、AES加密
-(void)AESEncrypt
{
    NSString *origin_str = @"abcdefgh";
    
    NSString *des_key = @"01234567";

    NSData *origin_data = [origin_str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *des_key_data = [des_key dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [[NSData alloc] AES_CBC_EncryptWith:des_key_data iv:origin_data];
    
    
    NSLog(@"data:%@",data);
    
    
}


//2、DES加密

-(void)DESEncrypt
{
    NSString *origin_str = @"abcdefgh";
    
    NSString *des_key = @"01234567";
    
    NSString *cipher_str = [DES3Util encryptUseDES:origin_str key:des_key];
    
    NSLog(@"cipher_str:%@",cipher_str);
    
    [self DESdecrypt:cipher_str];
    
}

-(void)DESdecrypt:(NSString *)cipher_str
{
    NSString *des_key = @"01234567";
    
    NSString *ci_str = @"gAAAAABYa5oylytlKzCr9GpVdCBI5xXQ8RnGZUi29JJW_Pjf4RzB4leTUNA25KH97pZ4Fo5JQGliqoAkbKWSqM-q51pX_3Kaqw==";
    
    NSString *origin_str = [DES3Util decryptUseDES:cipher_str key:des_key];
    
    NSLog(@"origin_str:%@",origin_str);
    
}



//1、动态的生成密码对
- (void)generateRSAKeyPair:(int )keySize
{
    if (publicKeyRef) {
        return;
    }
    OSStatus ret = 0;
    publicKeyRef = NULL;
    privateKeyRef = NULL;
    ret = SecKeyGeneratePair((CFDictionaryRef)@{(id)kSecAttrKeyType:(id)kSecAttrKeyTypeRSA,(id)kSecAttrKeySizeInBits:@(keySize)}, &publicKeyRef, &privateKeyRef);
    NSAssert(ret==errSecSuccess, @"密钥对生成失败：%d",ret);
    
    NSLog(@"公钥publicKeyRef:%@\n",publicKeyRef);
    NSLog(@"私钥privateKeyRef:%@\n",privateKeyRef);
    NSLog(@"max size:%lu\n\n",SecKeyGetBlockSize(privateKeyRef));
    
}


//公钥加密私钥密钥测试
/** 三种填充方式区别
 kSecPaddingNone      = 0,   要加密的数据块大小<＝SecKeyGetBlockSize的大小，如这里128
 kSecPaddingPKCS1     = 1,   要加密的数据块大小<=128-11
 kSecPaddingOAEP      = 2,   要加密的数据块大小<=128-42
 密码学中的设计原则，一般用RSA来加密 对称密钥，用对称密钥加密大量的数据
 非对称加密速度慢，对称加密速度快
 */
- (void)testRSAEncryptAndDecrypt
{
    [self generateRSAKeyPair:kRSA_KEY_SIZE];
    
    NSData *srcData = [@"0123456789孟" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"srcData:%@",srcData);
    uint8_t encData[kRSA_KEY_SIZE/8] = {0};
    uint8_t decData[kRSA_KEY_SIZE/8] = {0};
    size_t blockSize = kRSA_KEY_SIZE / 8 ;
    OSStatus ret;
    
    ret = SecKeyEncrypt(publicKeyRef, kSecPaddingNone, srcData.bytes, srcData.length, encData, &blockSize);
    NSAssert(ret==errSecSuccess, @"加密失败");
    
    ret = SecKeyDecrypt(privateKeyRef, kSecPaddingNone, encData, blockSize, decData, &blockSize);
    NSAssert(ret==errSecSuccess, @"解密失败");
    
    NSData *dedData = [NSData dataWithBytes:decData length:blockSize];
    
    NSString *result = [[NSString alloc] initWithData:dedData  encoding:NSUTF8StringEncoding];
    NSLog(@"解密后的数据dec:%@\nresult:%@",dedData,result);
    
    if (memcmp(srcData.bytes, dedData.bytes, srcData.length)==0) {
        NSLog(@"PASS");
    }
}



#pragma mark 网络测试
-(void)setupRefresh
{
    UIRefreshControl *reVc = [[UIRefreshControl alloc]init];
    
    [reVc addTarget:self action:@selector(refreshStatusChage:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:reVc];
    
    [self refreshStatusChage:reVc];
    
}

-(void)refreshStatusChage:(UIRefreshControl *)control
{
    
    [self.listArray removeAllObjects];
    
    [self getRrxUserListBook];
    
    [control endRefreshing];
    
    
}

-(void)loadListUserInfo
{
    
    NSString *urlString = @"http://10.10.159.23:10007/client_simulator/get_all_users";
    
    
    NSDictionary *dict = @{
                           @"auth":@{
                                   @"name":@"rrx_crawler_test",
                                   @"token":@"1"
                                  }
                           };
    
//     __weak typeof(self) weakself = self;
    
    [[MZNetworkTools sharedTools] request:POST URLString:urlString parameters:dict finished:^(id result, NSError *error) {
        
        NSLog(@"MZ___返回的数据类型是%@---返回的数据是%@",[result class],result);
        
    }];

}


-(void)getRrxUserListBook
{
    NSURL *url = [NSURL URLWithString:@"http://news.coolban.com/Api/Index/news_list/app/2/cat/0/limit/20/time/1457168894/type/0?channel=appstore&uuid=19C2BF6A-94F8-4503-8394-2DCD07C36A8F&net=5&model=iPhone&ver=1.0.5"];
    

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    __weak typeof(self) weakself = self;
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil && data != nil && data.length > 0) {
            
            NSMutableArray *resultDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            if (error == nil) {
                
                NSLog(@"RRXUserListController-获取用户列表\ndict:%@\nresponse:%@\n---%@",resultDict,response,[resultDict class]);
                
                [weakself.listArray addObjectsFromArray:resultDict];
 
                dispatch_sync(dispatch_get_main_queue(), ^(){
                    // 这里的代码会在主线程执行
                     [weakself.tableView reloadData];
                });
               
            }else{
                
                NSLog(@"error:%@",error);
            }
            
        }
        
    }];
    
    [dataTask resume];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    NSLog(@"count:%lu",(unsigned long)self.listArray.count);
    return self.listArray.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *key = @"userKey";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:key];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:key];
    }
    
    cell.backgroundColor=[UIColor greenColor];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = self.listArray[indexPath.row][@"title"];
    
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end
