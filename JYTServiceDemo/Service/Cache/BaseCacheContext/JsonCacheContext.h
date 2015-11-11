//
//  JsonCacheContext.h
//  daydays
//
//  Created by bihongbo on 10/8/15.
//  Copyright © 2015 daydays. All rights reserved.
//

#import "BaseCacheContext.h"

/**
 *  json缓存数据包，用来存入NSCache
 */

@interface JsonCachePackage : NSObject

/**
 *  拼接好的参数字符串，用来作为json数据的键
 */
@property (nonatomic, strong) NSString * paramKey;
/**
 *  保存数据结果的字典
 */
@property (nonatomic, strong) NSDictionary * result;
/**
 *  md5校验，用来校验数据唯一性
 */
@property (nonatomic, strong) NSString * md5;

@end

/**
 *  json模式缓存策略，当你在BaseService中的baseServiceWithURLString方法传入json模式对象的时候，缓存功能就会开启，缓存策略的流程为三级缓存：
 读取数据时：内存->硬盘->网络请求
 更新数据时：网络请求—>内存－>硬盘
 */

@interface JsonCacheContext : BaseCacheContext

/**
 *  过期时间
 */
@property (nonatomic, assign) NSTimeInterval timeExpired;

/**
 *  数据库文件存储路径
 */
+ (NSString *)dataBaseSavePath;

@end
