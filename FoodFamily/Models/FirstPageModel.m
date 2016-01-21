//
//  FirstPageModel.m
//  FoodFamily
//
//  Created by qianfeng on 15/12/21.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "FirstPageModel.h"

@implementation FirstPageModel

+ (NSMutableArray*)parseRespondsData:(NSDictionary*)dictionary{
    NSMutableArray *modelArray = [NSMutableArray array];
    NSArray *dataArray = dictionary[@"data"];
    for (NSDictionary *dic in dataArray) {
        FirstPageModel *model = [[FirstPageModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [modelArray addObject:model];
    }
    return modelArray;
}

@end
