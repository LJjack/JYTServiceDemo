//
//  BaseCacheOperationManager.h
//  daydays
//
//  Created by bihongbo on 9/24/15.
//  Copyright © 2015 daydays. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCacheContext.h"

/**
 *  单例宏
 */

#define BHBSingletonH(methodName) + (instancetype)shared##methodName;
#if __has_feature(objc_arc) // 是ARC
#define BHBSingletonM(methodName) \
static id instace = nil; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
if (instace == nil) { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instace = [super allocWithZone:zone]; \
}); \
} \
return instace; \
} \
\
- (id)init \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instace = [super init]; \
}); \
return instace; \
} \
\
+ (instancetype)shared##methodName \
{ \
return [[self alloc] init]; \
} \
- (id)copyWithZone:(struct _NSZone *)zone \
{ \
return instace; \
} \
\
- (id)mutableCopyWithZone:(struct _NSZone *)zone{\
return instace;\
}
#else // 不是ARC
#define BHBSingletonM(methodName) \
static id instace = nil; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
if (instace == nil) { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instace = [super allocWithZone:zone]; \
}); \
} \
return instace; \
} \
\
- (id)init \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instace = [super init]; \
}); \
return instace; \
} \
\
+ (instancetype)shared##methodName \
{ \
return [[self alloc] init]; \
} \
\
+ (oneway void)release \
{ \
\
} \
\
- (id)retain \
{ \
return self; \
} \
\
- (NSUInteger)retainCount \
{ \
return 1; \
} \
- (id)copyWithZone:(struct _NSZone *)zone \
{ \
return instace; \
} \
- (id)mutableCopyWithZone:(struct _NSZone *)zone \
{ \
return instace; \
}
#endif

typedef void(^SuccessBlock)(id responseObject);

typedef void(^FaildBlock)(NSError * error);

/**
 *  缓存层管理类，用来发起一个缓存任务
 */

@interface BaseCacheOperationManager : NSObject

/**
 *  任务队列
 */
@property (nonatomic, readonly, strong) NSOperationQueue * operationQueue;

BHBSingletonH(BaseCacheOperationManager)

/**
 *  拉取缓存中的数据
 *
 *  @param url          请求地址
 *  @param param        请求参数
 *  @param context      缓存上下文
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 *
 *  @return 操作单元
 */
- (BaseCacheOperation *)fetchDataWithUrlString:(NSString *)url andParam:(NSDictionary *)param andContext:(BaseCacheContext *)context andSuccess:(SuccessBlock)successBlock andFaild:(FaildBlock)faildBlock;

/**
 *  将数据压入缓存中
 *
 *  @param url     请求地址
 *  @param param   请求参数
 *  @param result  请求结果
 *  @param context 缓存上下文
 *
 *  @return 操作单元
 */
- (BaseCacheOperation *)pushDataWithUrlString:(NSString *)url andParam:(NSDictionary *)param andResult:(NSDictionary *)result andContext:(BaseCacheContext *)context;

/**
 *  取消所有操作
 */
- (void)cancelAllOperations;

@end
