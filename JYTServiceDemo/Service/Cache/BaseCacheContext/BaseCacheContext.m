//
//  BaseCacheContext.m
//  daydays
//
//  Created by bihongbo on 9/25/15.
//  Copyright © 2015 daydays. All rights reserved.
//

#import "BaseCacheContext.h"


@implementation BaseCacheContext

- (void)fetchDataWithUrlString:(NSString *)url andParam:(NSDictionary *)param andSuccess:(SuccessBlock)successBlock andFaild:(FailedBlock)faildBlock{
    self.urlString = url;
    self.param = param;
    self.sucessBlock = successBlock;
    self.failedBlock = faildBlock;
    if(self.type != CacheContextTypeNone)
    self.type = CacheContextTypeFetch;
}

- (void)pushDataWithUrlString:(NSString *)url andParam:(NSDictionary *)param andResult:(NSDictionary *)result{
    self.urlString = url;
    self.param = param;
    self.result = result;
    if(self.type != CacheContextTypeNone)
    self.type = CacheContextTypePush;
}

- (void)main{
    @synchronized(self.cache) {
        if (self.type == CacheContextTypeFetch) {
            [self fetch];
        }else if(self.type == CacheContextTypePush){
            [self push];
        }else if(self.type == CacheContextTypeNone){
            [self none];
        }
    }
}

-(void)fetch{
    
}

- (void)push{
    
}

-(void)none{
    NSError * error = [NSError errorWithDomain:@"缓存层未实现" code:1000 userInfo:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.failedBlock){
            self.failedBlock(error);
        }
    });
}

@end
