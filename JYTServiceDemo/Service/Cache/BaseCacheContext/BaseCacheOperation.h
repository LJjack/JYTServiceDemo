//
//  BaseCacheOperation.h
//  daydays
//
//  Created by bihongbo on 9/24/15.
//  Copyright © 2015 daydays. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCacheContext.h"

/**
 *  操作的基本单元，加入operation队列后会自动调用context属性的main方法。
 */

@interface BaseCacheOperation : NSOperation

/**
 *  缓存上下文，当缓存操作被执行的时候会调用上下文的main()方法
 */
@property (nonatomic, strong) BaseCacheContext * context;

@end
