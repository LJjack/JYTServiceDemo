//
//  BaseService.h
//  daydays
//
//  Created by bihongbo on 9/21/15.
//  Copyright © 2015 daydays. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCacheOperation.h"
#import "BaseCacheOperationManager.h"
#import "BaseCacheContext.h"
#import "DataAdapter.h"
#import "ServiceControlManager.h"
#import "Result.h"
#import "Param.h"
#import "JsonCacheContext.h"

typedef enum : NSUInteger {
    ServiceRequestTypePost,
    ServiceRequestTypeGet
} ServiceRequestType;

/**请求失败block*/
typedef void(^FailedBlock)(NSError *error);

/**
 *  基础业务类，它是整个业务层的基础，你可以使用这个类来设置公共请求参数与任务最大并发数。针对发出去的业务请求可以通过对应类ServiceControlManager来取消。
 */

@interface BaseService : NSObject

/**
 *  添加公共参数（模型）
 *
 *  @param publicParam 公共参数模型
 */
+ (void)setPublicParam:(id)publicParam;
/**
 *  添加公共参数（字典）
 *
 *  @param paramDict 公共参数字典
 */
+ (void)setPublicParamDict:(NSDictionary *)paramDict;

/**
 *  添加公共参数，即时刷新，每次请求都会调用这个block拼接默认参数,设置了block之后setPublicParam:与setPublicParamDict:将会失效
 *
 *  @param block
 */
+ (void)setPublicParamBlock:(PublicParamBlock)block;

/**
 *  设置网络请求最大并发数
 *
 *  @param count 并发数
 */
+ (void)setNetWorkMaxConcurrentOperationCount:(int)count;
/**
 *  设置缓存操作最大并发数
 *
 *  @param count 并发数
 */
+ (void)setCacheMaxConcurrentOperationCount:(int)count;

/**
 *  设置请求超时时间
 *
 *  @param time 时长
 */
+ (void)setTimeOutInteval:(NSTimeInterval)time;

/**
 *  业务类基本方法
 *
 *  @param urlString    请求地址
 *  @param class        结果数据模型类型
 *  @param param        请求参数
 *  @param context      缓存模式上下文
 *  @param type         请求方式（get、post）
 *  @param successBlock 成功回调
 *  @param failedBlock  失败回调
 *
 *  @return 业务控制类
 */
+ (ServiceControlManager *)baseServiceWithURLString:(NSString *)urlString andResultClass:(Class)class andParam:(id)param andCacheContext:(BaseCacheContext *)context andRequestType:(ServiceRequestType)type success:(void(^)(id result))successBlock andFailed:(FailedBlock)failedBlock;

/**
 *  取消所有请求
 */
+ (void)cancelAllServices;

@end
