//
//  BaseCacheOperationManager.m
//  daydays
//
//  Created by bihongbo on 9/24/15.
//  Copyright © 2015 daydays. All rights reserved.
//

#import "BaseCacheOperationManager.h"

@interface BaseCacheOperationManager ()

@property (nonatomic, strong) NSOperationQueue * operationQueue;
@property (nonatomic, strong) NSCache * cache;

@end

@implementation BaseCacheOperationManager
BHBSingletonM(BaseCacheOperationManager)

-(NSOperationQueue *)operationQueue{
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc]init];
        _operationQueue.maxConcurrentOperationCount = 10;
    }
    return _operationQueue;
}

-(NSCache *)cache{
    if (!_cache) {
        _cache = [[NSCache alloc] init];
    }
    return _cache;
}

- (void)cancelAllOperations{
    [self.operationQueue cancelAllOperations];
}

- (BaseCacheOperation *)fetchDataWithUrlString:(NSString *)url andParam:(NSDictionary *)param andContext:(BaseCacheContext *)context andSuccess:(SuccessBlock)successBlock andFaild:(FaildBlock)faildBlock{
    BaseCacheOperation * operation = [[BaseCacheOperation alloc]init];
    if(!context){
        context = [[BaseCacheContext alloc]init];
        context.type = CacheContextTypeNone;
    }
    context.cache = self.cache;
    [context fetchDataWithUrlString:url andParam:param andSuccess:successBlock andFaild:faildBlock];
    operation.context = context;
    [self.operationQueue addOperation:operation];
    return operation;
}

- (BaseCacheOperation *)pushDataWithUrlString:(NSString *)url andParam:(NSDictionary *)param andResult:(NSDictionary *)result andContext:(BaseCacheContext *)context{
    BaseCacheOperation * operation = [[BaseCacheOperation alloc]init];
    if(!context){
        context = [[BaseCacheContext alloc]init];
        context.type = CacheContextTypeNone;
    }
    context.cache = self.cache;
    [context pushDataWithUrlString:url andParam:param andResult:result];
    [self.operationQueue addOperation:operation];
    operation.context = context;
    return operation;
}

@end
