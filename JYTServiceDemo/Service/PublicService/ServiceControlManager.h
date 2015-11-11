//
//  ServiceControlManager.h
//  daydays
//
//  Created by bihongbo on 9/24/15.
//  Copyright © 2015 daydays. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCacheOperation.h"

/**
 *  业务控制类，这个类保存了业务请求的控制对象，通过控制对象，你可以设置和取消请求或缓存的状态。
 */
@interface ServiceControlManager : NSObject

/**
 *  网络控制任务对象，调用它的cancel可以单纯取消网络
 */
@property (nonatomic, strong) NSURLSessionDataTask * requestOperation;

/**
 *  缓存控制任务对象，调用它的cancel可以单纯取消缓存
 */
@property (nonatomic, strong) BaseCacheOperation * cacheOperation;

/**
 *  取消所有业务，包括网络请求与缓存
 */
- (void)cancel;

@end
