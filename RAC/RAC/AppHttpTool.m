//
//  AppHttpTool.m
//  RAC
//
//  Created by zhouyuxi on 2017/11/23.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import "AppHttpTool.h"
#import <AdSupport/AdSupport.h>

#import <AFNetworking/AFNetworking.h>



#define kHeadAccept @"application/json"
#define kHeadVersion  @"qsc_ios/3.0.7/v6"

@implementation AppHttpTool
+ (void)post:(NSString *)url parameters:(id )parameters httpToolSuccess:(QSCSuccess)httpToolSuccess failure:(QSCFailure)failure
{
    AFHTTPSessionManager *manager = [self getAFHTTPRequestOperationManager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (httpToolSuccess) {
            [self successWithResponseObject:responseObject httpToolSuccess:httpToolSuccess failure:failure];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            [self failureOperation:task error:error];
        }
    }];
}

+ (AFHTTPSessionManager *)getAFHTTPRequestOperationManager
{
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 20.f;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:config];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];  //设置请求格式json
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/javascript",@"text/html",nil];
    [manager.requestSerializer setValue:kHeadAccept forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"Bearer "  forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:kHeadVersion  forHTTPHeaderField:@"Platform"];
    NSString *idfa= [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [manager.requestSerializer setValue:idfa  forHTTPHeaderField:@"DeviceId"];  // 添加idfa标示
    
    manager.requestSerializer.timeoutInterval = 20.f;
    
    NSLog(@"请求头-----%@",manager.requestSerializer.HTTPRequestHeaders);
    return manager;
}

+ (void)successWithResponseObject:(id)responseObject httpToolSuccess:(QSCSuccess)httpToolSuccess failure:(QSCFailure)failure
{
    httpToolSuccess(responseObject);
}

+ (void)failureOperation:(NSURLSessionDataTask *)task error:(NSError *)error
{
    
    
}
@end
