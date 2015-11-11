//
//  JsonDataBaseTool.m
//  daydays
//
//  Created by bihongbo on 15/10/8.
//  Copyright © 2015年 daydays. All rights reserved.
//

#import "JsonDataBaseTool.h"

@implementation JsonDataBaseTool

/**
 *  创建数据库并获取数据库队列
 */
+ (FMDatabaseQueue *)queue{
    
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString * dbPath = [docPath stringByAppendingPathComponent:@"JYTJsonDB.db"];
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [queue inDatabase:^(FMDatabase *db) {
        [db open];
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS jsondata(jsonkey TEXT PRIMARY KEY,jsonresult TEXT,time DATE,md5 TEXT);"];
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS databaseversion(version TEXT);"];
        [db executeUpdate:@"INSERT INTO databaseversion values(?);" withArgumentsInArray:@[@"1.0.0"]];
        [db close];
    }];
    return queue;
}

@end
