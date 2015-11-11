//
//  BaseCacheOperation.m
//  daydays
//
//  Created by bihongbo on 9/24/15.
//  Copyright © 2015 daydays. All rights reserved.
//

#import "BaseCacheOperation.h"

@implementation BaseCacheOperation

- (void)main{
    @autoreleasepool {
        if(self.context && !self.isCancelled)
            [self.context main];
        else{
            NSLog(@"读取缓存被取消");
        }
    }
}

@end
