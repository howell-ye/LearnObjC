//
//  NetworkCenter.m
//  LearnObjC
//
//  Created by eshore on 2017/7/25.
//  Copyright © 2017年 howell. All rights reserved.
//

#import "NetworkCenter.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonCryptor.h>

@interface NetworkCenter()

@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation NetworkCenter

+ (NetworkCenter *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

-(instancetype)init{
    self = [super init];
    if(self){
        if(!_params){
            [self getParams];
        }
    }
    return self;
}


-(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionTask *, id))success failure:(void (^)(NSURLSessionTask *, NSError *))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"eshore" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"utf-8" forHTTPHeaderField:@"Accept-Charset"];
    manager.requestSerializer.timeoutInterval = 30;
    
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject isKindOfClass:[NSData class]]){
            NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success((NSURLSessionDataTask *)task,content);
        }else{
            success((NSURLSessionDataTask *)task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(NSURLSessionTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"utf-8" forHTTPHeaderField:@"Accept-Charset"];
    manager.requestSerializer.timeoutInterval = 30;
    
    NSDictionary *params = parameters;
    
    [manager GET:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if([responseObject isKindOfClass:[NSData class]]){
            success((NSURLSessionDataTask *)task,responseObject);
        }else{
            success((NSURLSessionDataTask *)task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure((NSURLSessionDataTask *)task,error);
    }];
}

- (void)postWithPath:(NSString *)path parameters:(NSDictionary *)parameters success:(ResponseSuceess)success failure:(ResponseFail)failure
{
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    request.allowsCellularAccess = YES;
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    request.timeoutInterval = 30;
    
    NSMutableDictionary *params = [self.params mutableCopy];
    for(int i=0;i<params.allKeys.count;i++){
        NSString *key = params.allKeys[i];
        NSString *value = params[key];
        [request addValue:value forHTTPHeaderField:key];
    }
    
    NSString *JSONString=[self dictionaryToJson:parameters];
    
    {
        NSData *encryptedData=[self encryptString:JSONString withDESKey:[self desKey]];
        NSString *hexString = [self hexdecimalStringFromData:encryptedData];
        [request setHTTPBody:[hexString dataUsingEncoding:NSUTF8StringEncoding]];
        
//        [request setHTTPBody:[JSONString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:@"https://gykd.10000.gd.cn"]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer.timeoutInterval = 30;
//    manager.securityPolicy = [self customSecurityPolicy];
    
    [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSString *decodeJSONString = [self decodeData:responseObject Key:[self desKey]];
            NSDictionary *content = [self dictionaryWithJsonString:decodeJSONString];
//            NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"Reply Dictionary: %@", content);

        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
}

- (AFSecurityPolicy*)customSecurityPolicy
{
    // 先导入证书 -- 这里要判断环境
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"gykd" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = NO;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;
    
    if (!certData) {
        return securityPolicy;
    }
    NSSet *set = [NSSet setWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}



/**
 *  请求接口的默认参数
 */
- (NSMutableDictionary *)getParams
{
    if (!_params)
    {
        NSString *version_name = [self versionName];
        NSString *version_code = [version_name stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSString *model = @"iPhone 7 Plus";
        NSString *uuid = @"1500893625188EvQ7WO5V4GmmKUkXQ7HxcQ";
        
        _params = [NSMutableDictionary new];
        [_params setObject:@"00004" forKey:@"channel_id"];           //渠道号
        [_params setObject:version_name forKey:@"client_version_name"];     //版本名称
        [_params setObject:version_code forKey:@"client_version_code"];     //版本编码
        [_params setObject:model forKey:@"client_model"];                   //设备型号
        [_params setObject:uuid forKey:@"client_imei"];                     //终端唯一设备码  采用uuid
        [_params setObject:@"ios" forKey:@"platform"];                        //应用平台类型 1.	android  2.	ios
        [_params setObject:@"0" forKey:@"e_type"];
//#if  isEncrypt
                                  //加密通道 0.默认加密。1.未加密
//#else
//        [_params setObject:@"1" forKey:@"e_type"];                          //加密通道 0.默认加密。1.未加密
//#endif
        
    }
    return _params;
    
}

- (NSString*)dictionaryToJson:(NSDictionary *)dict
{
    if (!dict)
        return @"";
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:jsonData
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        
        return nil;
    }
    return dic;
}

-(NSString *)versionName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

/**
 *  3des解密
 */
- (NSString *)decryptData:(NSData *)data withDESKey:(NSString *)key
{
    const void *input = data.bytes;
    size_t inputSize = data.length;
    
    size_t bufferSize = data.length;
    uint8_t *buffer = malloc( bufferSize * sizeof(uint8_t));
    memset((void *)buffer, 0x0, bufferSize);
    size_t movedBytes = 0;
    
    const void *vkey = [key dataUsingEncoding:NSUTF8StringEncoding].bytes;
    
    CCCryptorStatus ccStatus = CCCrypt(kCCDecrypt,
                                       kCCAlgorithm3DES,
                                       kCCOptionECBMode|kCCOptionPKCS7Padding,
                                       vkey,
                                       kCCKeySize3DES,
                                       NULL,
                                       input,
                                       inputSize,
                                       (void *)buffer,
                                       bufferSize,
                                       &movedBytes);
    
    if (ccStatus != kCCSuccess) {
        free(buffer);
        return nil;
    }
    
    NSData *decrypted = [NSData dataWithBytes:(const void *)buffer length:(NSUInteger)movedBytes];
    free(buffer);
    return [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
}

/**
 *  3des加密
 */
- (NSData *)encryptString:(NSString *)string withDESKey:(NSString *)key
{
    NSData *data=[string dataUsingEncoding:NSUTF8StringEncoding];
    const void *input = data.bytes;
    size_t inputSize = data.length;
    
    size_t bufferSize = (inputSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    uint8_t *buffer = malloc( bufferSize * sizeof(uint8_t));
    memset((void *)buffer, 0x0, bufferSize);
    size_t movedBytes = 0;
    
    const void *vkey = [key dataUsingEncoding:NSUTF8StringEncoding].bytes;
    
    CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt,
                                       kCCAlgorithm3DES,
                                       kCCOptionECBMode|kCCOptionPKCS7Padding,
                                       vkey,
                                       kCCKeySize3DES,
                                       NULL,
                                       input,
                                       inputSize,
                                       (void *)buffer,
                                       bufferSize,
                                       &movedBytes);
    if (ccStatus != kCCSuccess) {
        free(buffer);
        return nil;
    }
    NSData *encrypted = [NSData dataWithBytes:(const void *)buffer length:(NSUInteger)movedBytes];
    free(buffer);
    return encrypted;
}

/**
 *  把加密的data转换 hex(16进制)字符串后
 *  @params  data  hex(16进制的)Data类型
 */
- (NSString *)decodeData:(NSData *)data Key:(NSString *)key
{
    NSString *raw=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];//16进制字符串
    raw = [raw lowercaseString];
    NSRange range = [raw rangeOfString:@"{"];
    if (range.location != NSNotFound) {
        return nil;
    }
    NSData *rawData=[self dataFromHexdecimalString:raw];//16进制转换成data，data是3des的data
    NSString *decryptdStr=[self decryptData:rawData withDESKey:key];
    if (decryptdStr==nil) {
        return nil;
    }
    return decryptdStr;
}

/**
 *  hex(16进制)字符串转NSData
 */

-(NSData *) dataFromHexdecimalString:(NSString *) hexstr
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSString *inputStr = [hexstr uppercaseString];
    
    NSString *hexChars = @"0123456789ABCDEF";
    
    Byte b1,b2;
    b1 = 255;
    b2 = 255;
    for (int i=0; i<hexstr.length; i++) {
        NSString *subStr = [inputStr substringWithRange:NSMakeRange(i, 1)];
        NSRange loc = [hexChars rangeOfString:subStr];
        
        if (loc.location == NSNotFound) continue;
        
        if (255 == b1) {
            b1 = (Byte)loc.location;
        }else {
            b2 = (Byte)loc.location;
            
            //Appending the Byte to NSData
            Byte *bytes = malloc(sizeof(Byte) *1);
            bytes[0] = ((b1<<4) & 0xf0) | (b2 & 0x0f);
            [data appendBytes:bytes length:1];
            
            b1 = b2 = 255;
        }
    }
    
    return data;
}


/**
 *  NSData转hex(16进制)字符串
 */
- (NSString *)hexdecimalStringFromData:(NSData *)data
{
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:[hexString uppercaseString]];
}

- (NSString *)desKey
{
    NSString *desKey = nil;
    NSString *channel_id = @"00004";
    NSString *version_name = [self versionName];
    NSString *version_code = [version_name stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *platform = @"ios";
    NSString *random = @"ctb_123456Ab";
    NSString *secretKey = [NSString stringWithFormat:@"%@%@%@%@",channel_id,version_code,platform,random];
    
    if (secretKey.length > 24) {
        
        secretKey = [secretKey substringToIndex:24];
    }
    else if(secretKey.length < 24)
    {
        NSInteger leng = 24 - secretKey.length;
        NSString *zero = @"";
        for (NSInteger i = 0; i < leng; i++) {
            
            zero = [NSString stringWithFormat:@"%@%@",zero,@"0"];
        }
        
        secretKey = [NSString stringWithFormat:@"%@%@",secretKey,zero];
    }
    
    desKey = secretKey;
    
    return desKey;
}

@end
