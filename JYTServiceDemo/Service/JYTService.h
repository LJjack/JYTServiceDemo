//
//  Service.h
//  daydays
//
//  Created by bihongbo on 9/22/15.
//  Copyright © 2015 daydays. All rights reserved.
//

/**
 *  业务层头文件
 */

#ifndef Service_h
#define Service_h

#import "Param.h"
#import "Result.h"

#import "BaseService.h"
#import "ServiceControlManager.h"
#import "DataAdapter.h"
#import "BaseCacheOperationManager.h"
#import "BaseCacheOperation.h"
#import "BaseCacheContext.h"
#import "JsonCacheContext.h"
#import "ServiceControlManager.h"

/** 错误码 */
#define kErrorCode1000 @"未实现缓存层"
#define kErrorCode1001 @"网络返回结果不存在"
#define kErrorCode1002 @"缓存中不存在查找数据"

#endif /* Service_h */
