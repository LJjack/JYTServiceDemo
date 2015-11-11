//
//  DataAdapter.h
//  daydays
//
//  Created by bihongbo on 9/22/15.
//  Copyright © 2015 daydays. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  数据流适配类，网络层与业务层的衔接，能实现面向模型最重要的类，主要做数据的解析与对接。
 */

typedef NSDictionary *(^PublicParamBlock)();

@interface DataAdapter : NSObject
BHBSingletonH(DataAdapter)

/**
 *  公共请求参数
 */
@property (nonatomic, strong) NSDictionary * publicParamDict;

/**
 *  获取公共请求参数的block，如果你想实现动态更新的公共参数，请使用此属性
 */
@property (nonatomic, copy) PublicParamBlock publickParamBlock;

/**
 *  网络层数据(json)->业务层数据(model)
 *
 *  @param
 *  @param modelClass 模型类
 *
 *  @return 模型
 */
- (id)netWorkToServiceWith:(NSDictionary *)result andModelClass:(Class)modelClass;

/**
 *  业务层数据(model)->网络层数据(json)
 *
 *  @param model 模型
 *
 *  @return 字典
 */
- (NSDictionary *)serviceToNetworkWithModel:(id)model;

@end
