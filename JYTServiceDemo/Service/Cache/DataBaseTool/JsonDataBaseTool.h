//
//  JsonDataBaseTool.h
//  daydays
//
//  Created by bihongbo on 15/10/8.
//  Copyright © 2015年 daydays. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

/**
 *  json模式缓存数据库工具类，用来快速获取一个json缓存数据库操作队列。
 */

@interface JsonDataBaseTool : NSObject

/**
 *  创建数据库并获取数据库队列
 */
+ (FMDatabaseQueue *)queue;

@end
