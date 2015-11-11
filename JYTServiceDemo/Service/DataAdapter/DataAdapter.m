//
//  DataAdapter.m
//  daydays
//
//  Created by bihongbo on 9/22/15.
//  Copyright © 2015 daydays. All rights reserved.
//

#import "DataAdapter.h"

@implementation DataAdapter
BHBSingletonM(DataAdapter)

- (id)netWorkToServiceWith:(NSDictionary *)result andModelClass:(Class)modelClass{
    return [modelClass objectWithKeyValues:result];
}

- (NSDictionary *)serviceToNetworkWithModel:(id)model{
    //请求参数字典
    NSDictionary * paramDict;
    paramDict = [model keyValues];
    //拼接请求公共参数
    if (self.publickParamBlock) {
        NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithDictionary:paramDict];
        [mDict addEntriesFromDictionary:self.publickParamBlock()];
        paramDict = [NSDictionary dictionaryWithDictionary:mDict];
    }else if(self.publicParamDict) {
        NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithDictionary:paramDict];
        [mDict addEntriesFromDictionary:self.publicParamDict];
        paramDict = [NSDictionary dictionaryWithDictionary:mDict];
    }
    return paramDict;
}

@end
