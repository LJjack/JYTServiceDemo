//
//  BaseCacheContext.h
//  daydays
//
//  Created by bihongbo on 9/25/15.
//  Copyright © 2015 daydays. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CacheProtocol <NSObject>

@required
/**
 *  从缓存中查询数据,当你想要扩展缓存策略的时候，你必须继承BaseCacheContext并且实现这个方法用来查询缓存。
 */
- (void)fetch;
/**
 *  向缓存中推入数据，当你想要扩展缓存策略的时候，你必须继承BaseCacheContext并且实现这个方法用来更新缓存数据。
 */
- (void)push;

@optional
/**
 *  啥都不干，如果你想在用户不使用缓存的时候做些什么，比如统计，你可以实现它（不推荐）。
 */
- (void)none;

@end

typedef enum : NSUInteger {
    CacheContextTypePush,//压入缓存
    CacheContextTypeFetch,//缓存中拉取
    CacheContextTypeNone//默认
} CacheContextType;

typedef void(^SuccessBlock)(id responseObject);

typedef void(^FailedBlock)(NSError * error);

/**
 *  缓存策略上下文基类，继承此类可以扩展缓存模式
 */

@interface BaseCacheContext : NSObject<CacheProtocol>

@property (nonatomic, copy) NSString * urlString;
@property (nonatomic, strong) NSDictionary * param;
@property (nonatomic, strong) NSDictionary * result;
@property (nonatomic, copy) SuccessBlock sucessBlock;
@property (nonatomic, copy) FailedBlock failedBlock;
@property (nonatomic, assign) CacheContextType type;
@property (nonatomic, weak) NSCache * cache;

/**
 *  拉取缓存数据
 *
 *  @param url          请求地址
 *  @param param        请求参数
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (void)fetchDataWithUrlString:(NSString *)url andParam:(NSDictionary *)param andSuccess:(SuccessBlock)successBlock andFaild:(FailedBlock)faildBlock;

/**
 *  将数据压入缓存
 *
 *  @param url    请求地址
 *  @param param  请求参数
 *  @param result 请求结果
 */
- (void)pushDataWithUrlString:(NSString *)url andParam:(NSDictionary *)param andResult:(NSDictionary *)result;

/**
 *  缓存任务，如果你想彻底扩展缓存模式，这里面你可以组织fetch，push等操作。
 */
- (void)main;



@end
