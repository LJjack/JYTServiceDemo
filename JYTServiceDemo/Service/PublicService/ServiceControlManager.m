//
//  ServiceControlManager.m
//  daydays
//
//  Created by bihongbo on 9/24/15.
//  Copyright © 2015 daydays. All rights reserved.
//

#import "ServiceControlManager.h"

@implementation ServiceControlManager

- (void)cancel{
    if(self.requestOperation)
    [self.requestOperation cancel];
    if(self.cacheOperation)
    [self.cacheOperation cancel];
}

@end
