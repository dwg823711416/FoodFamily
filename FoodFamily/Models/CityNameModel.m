//
//  CityNameModel.m
//  FoodFamily
//
//  Created by qianfeng on 16/1/8.
//  Copyright © 2016年 杜卫国. All rights reserved.
//

#import "CityNameModel.h"

@implementation CityNameModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"捕获到未定义的key=[%@]",key);
}

- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

+ (NSArray *) analysisData:(NSData *)data{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = dic[@"城市代码"];
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        CityNameModel *model = [[CityNameModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [modelArray addObject:model];
    }
//    for (CityNameModel *model in modelArray) {
//        NSLog(@"=====省=====%@",model.省);
//        for (NSDictionary *dic in model.市) {
//            NSLog(@"%@",dic[@"市名"]);
//        }
//    }
        return modelArray;
}
@end
