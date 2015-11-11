//
//  JsonCacheContext.m
//  daydays
//
//  Created by bihongbo on 10/8/15.
//  Copyright © 2015 daydays. All rights reserved.
//

#import "JsonCacheContext.h"
#import "JsonDataBaseTool.h"
#import "JYTService.h"
#import <CommonCrypto/CommonDigest.h>

@implementation JsonCachePackage

@end

@implementation JsonCacheContext
+ (NSString *)dataBaseSavePath{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString * dbPath = [docPath stringByAppendingPathComponent:@"JYTJsonDB.db"];
    return dbPath;
}

+ (NSString *)jsonWithDict:(NSDictionary *)dict{
    NSString * json;
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    if (!json) {
        json = @"";
    }
    return json;

}

+ (NSString *)md5String:(NSString *)inString{
    const int MD5Bit = 16;
    const char * cStr = [inString UTF8String];
    unsigned char result[MD5Bit];
    CC_MD5(cStr,(unsigned int)strlen(cStr),result);
    NSMutableString * md5String = [NSMutableString string];
    
    for (int i = 0; i < MD5Bit; i ++) {
        [md5String appendFormat:@"%x",result[i]];
    }
    return [md5String copy];
}

+ (NSDictionary *)dictWithJson:(NSString *)json{
    NSData * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error;
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return nil;
    }
    return dict;
}

-(void)fetch{
    //先在内存中查找
    NSString * paramKey = [self.urlString stringByAppendingString:[JsonCacheContext jsonWithDict:self.param]];
    JsonCachePackage * jp = [self.cache objectForKey:paramKey];
    //            NSLog(@"%@",self.cache);
    if (jp) {
        self.result = jp.result;
    }
    if (self.result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"内存中来的数据");
            self.sucessBlock(self.result);
        });
    }else{//内存中不存在，去数据库中查找
        FMDatabaseQueue * queue = [JsonDataBaseTool queue];
        [queue inDatabase:^(FMDatabase *db) {
            [db open];
            FMResultSet * rs = [db executeQuery:@"SELECT * FROM jsondata WHERE jsonkey=?" withArgumentsInArray:@[paramKey]];
            if ([rs next]) {//有数据
                NSString * resultString = [rs stringForColumn:@"jsonresult"];
                self.result = [JsonCacheContext dictWithJson:resultString];
                JsonCachePackage * pack = [[JsonCachePackage alloc]init];
                pack.result = [self.result copy];
                pack.paramKey = [paramKey copy];
                pack.md5 = [rs stringForColumn:@"md5"];
                //将硬盘中的数据加入内存缓存
                [self.cache setObject:pack forKey:paramKey];
                NSLog(@"硬盘中数据插入内存");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"硬盘中来的数据");
                    self.sucessBlock(self.result);
                });
                [db close];
                
            }else{//无数据
                NSError * error = [NSError errorWithDomain:kErrorCode1002 code:1002 userInfo:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.failedBlock(error);
                });
                [db close];
            }
        }];
    }

}


-(void)push{
    if (!self.result) {
        NSError * error = [NSError errorWithDomain:kErrorCode1001 code:1001 userInfo:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.failedBlock(error);
        });
        return;
    }
    // 将请求参数与url合并成字符串作为key存储请求结果到内存中
    NSString * paramKey = [self.urlString stringByAppendingString:[JsonCacheContext jsonWithDict:self.param]];
    JsonCachePackage * package = [[JsonCachePackage alloc]init];
    package.paramKey = paramKey;
    package.result = self.result;
    NSString * resultJson = [JsonCacheContext jsonWithDict:self.result];
    
    //如果内存中也存在数据，将结果与内存中进行md5对比
    NSString * md5Source = [NSString stringWithFormat:@"%@%@",paramKey,resultJson];
    package.md5 = [JsonCacheContext md5String:md5Source];
    JsonCachePackage * cachePack = [self.cache objectForKey:paramKey];
    if (cachePack) {
        if ([cachePack.md5 isEqualToString:package.md5]) {//已经存在相同数据，避免重复插入
            NSLog(@"存入数据,内存中已经存在");
            return;
        }
    }
    [self.cache setObject:package forKey:paramKey];
    NSLog(@"插入内存");
    // 数据库存储请求结果保存到硬盘中
    FMDatabaseQueue * queue = [JsonDataBaseTool queue];
    [queue inDatabase:^(FMDatabase *db) {
        [db open];
        NSLog(@"插入硬盘");
        [db executeUpdate:@"REPLACE INTO jsondata VALUES(?,?,?,?)" withArgumentsInArray:@[package.paramKey,resultJson,[NSDate date],package.md5]];
        [db close];
    }];

}

- (void)none{
    NSError * error = [NSError errorWithDomain:kErrorCode1000 code:1000 userInfo:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.failedBlock(error);
    });

}


@end
