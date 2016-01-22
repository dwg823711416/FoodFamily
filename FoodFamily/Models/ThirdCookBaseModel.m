//
//  ThirdCookBaseModel.m
//  FoodFamily
//
//  Created by qianfeng on 16/1/22.
//  Copyright © 2016年 杜卫国. All rights reserved.
//

#import "ThirdCookBaseModel.h"
#import "ThirdCookModel.h"

@implementation ThirdCookBaseModel
+ (NSMutableArray*)parseRespondsData:(NSDictionary*)dictionary{
    ThirdCookBaseModel *model = [[ThirdCookBaseModel alloc]init];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [model setValuesForKeysWithDictionary:dictionary];
    
    NSMutableArray *cookArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in model.steps) {
        ThirdCookModel * cookModel = [[ThirdCookModel alloc]init];
        [cookModel setValuesForKeysWithDictionary:dic];
        [cookArr addObject:cookModel];
    }

    model.steps = cookArr;
    
    [arr addObject:model];
    
    return arr;
}
@end
