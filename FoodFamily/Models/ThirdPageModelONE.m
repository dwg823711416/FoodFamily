//
//  ThirdPageModelONE.m
//  FoodFamily
//
//  Created by qianfeng on 16/1/21.
//  Copyright © 2016年 杜卫国. All rights reserved.
//

#import "ThirdPageModelONE.h"

@implementation ThirdPageModelONE
+ (NSMutableArray*)parseRespondsData:(NSDictionary*)dictionary{
    NSMutableArray *mArr = [[NSMutableArray alloc]init];
    NSArray *arr = dictionary[@"list"];
    for (NSDictionary *dic in arr) {
        ThirdPageModelONE *model = [[ThirdPageModelONE alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [mArr addObject:model];
    }
//    for (ThirdPageModelONE *model in mArr) {
//        NSLog(@"%@",model.title);
//    }
    return mArr;
}
@end
