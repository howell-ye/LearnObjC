//
//  NetworkCenter.h
//  LearnObjC
//
//  Created by eshore on 2017/7/25.
//  Copyright © 2017年 howell. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResponseSuceess)(NSURLSessionTask *task, id responseObject);
typedef void(^ResponseFail)(NSURLSessionTask *task, NSError *error);

@interface NetworkCenter : NSObject

+ (NetworkCenter *)sharedInstance;

-(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionTask *, id))success failure:(void (^)(NSURLSessionTask *, NSError *))failure;

- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(NSURLSessionTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;

- (void)postWithPath:(NSString *)path
          parameters:(NSDictionary *)parameters
             success:(ResponseSuceess)success
             failure:(ResponseFail)failure;

@end
