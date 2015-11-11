//
//  BaseService.m
//  daydays
//
//  Created by bihongbo on 9/21/15.
//  Copyright © 2015 daydays. All rights reserved.
//

#import "BaseService.h"
#import "AFHTTPSessionManager.h"

int TimeOut,MaxConcurrent;

@implementation BaseService

/**
 *  添加公共参数（模型）
 *
 *  @param publicParam 公共参数模型
 */
+ (void)setPublicParam:(id)publicParam{
    [[DataAdapter sharedDataAdapter] setPublicParamDict:[publicParam keyValues]];
}
/**
 *  添加公共参数（字典）
 *
 *  @param paramDict 公共参数字典
 */
+ (void)setPublicParamDict:(NSDictionary *)paramDict{
    [[DataAdapter sharedDataAdapter] setPublicParamDict:paramDict];
}

/**
 *  添加公共参数，即时刷新，每次请求都会调用这个block
 *
 *  @param block
 */
+ (void)setPublicParamBlock:(PublicParamBlock)block{
    [[DataAdapter sharedDataAdapter] setPublickParamBlock:block];
}

/**
 *  设置网络请求最大并发数
 *
 *  @param count 并发数
 */
+ (void)setNetWorkMaxConcurrentOperationCount:(int)count{
    MaxConcurrent = count;
}


/**
 *  设置缓存操作最大并发数
 *
 *  @param count 并发数
 */
+ (void)setCacheMaxConcurrentOperationCount:(int)count{
    [BaseCacheOperationManager sharedBaseCacheOperationManager].operationQueue.maxConcurrentOperationCount = count;
}

/**
 *  设置请求超时时间
 *
 *  @param time 时长
 */
+ (void)setTimeOutInteval:(NSTimeInterval)time{
    TimeOut = time;
}

+ (void)cancelAllServices{
    [[BaseCacheOperationManager sharedBaseCacheOperationManager] cancelAllOperations];
    [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
}

+ (ServiceControlManager *)baseServiceWithURLString:(NSString *)urlString andResultClass:(Class)class andParam:(id)param andCacheContext:(BaseCacheContext *)context andRequestType:(ServiceRequestType)type success:(void(^)(id result))successBlock andFailed:(FailedBlock)failedBlock{
    
    
    //参数数据由业务层流向模型层
    NSDictionary * pDict = [[DataAdapter sharedDataAdapter] serviceToNetworkWithModel:param];
    __block NSURLSessionDataTask * rq;//用于记录AFN操作类
    __block BOOL isCached;//缓存中是否存在
    //发起业务请求
    BaseCacheOperation * ca = [[BaseCacheOperationManager sharedBaseCacheOperationManager] fetchDataWithUrlString:urlString andParam:pDict andContext:context andSuccess:^(id responseObject) {//缓存中成功读取数据
        id result = [[DataAdapter sharedDataAdapter] netWorkToServiceWith:responseObject andModelClass:class];
        isCached = YES;
        successBlock(result);
    } andFaild:^(NSError *error) {//缓存读取失败
        isCached = NO;
    }];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TimeOut;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    if(type == ServiceRequestTypeGet){//get请求
        //调用网络层发起请求
        rq = [manager GET:urlString parameters:pDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            //网络层得到的数据流入业务层
            id result = [[DataAdapter sharedDataAdapter] netWorkToServiceWith:responseObject andModelClass:class];
            //结果得到后将数据压入缓存
            [[BaseCacheOperationManager sharedBaseCacheOperationManager] pushDataWithUrlString:urlString andParam:pDict andResult:responseObject andContext:context];
            //请求成功回调
            successBlock(result);
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            //请求失败回调
            if(!isCached)
            failedBlock(error);
        }];
    }
    else if(type == ServiceRequestTypePost){//post请求
        //调用网络层发起请求
        rq = [manager POST:urlString parameters:pDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            //结果得到后将数据压入缓存
            [[BaseCacheOperationManager sharedBaseCacheOperationManager] pushDataWithUrlString:urlString andParam:pDict andResult:responseObject andContext:context];
            //网络层得到的数据流入业务层
            id result = [[DataAdapter sharedDataAdapter] netWorkToServiceWith:responseObject andModelClass:class];
            //请求成功回调
            successBlock(result);
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            //请求失败回调
            if(!isCached)
            failedBlock(error);
        }];
    }

    
    //创建业务管理类并返回，它可以管理业务，取消业务等。
    ServiceControlManager * sManager = [[ServiceControlManager alloc]init];
    sManager.requestOperation = rq;
    sManager.cacheOperation = ca;
    return sManager;
}

@end
