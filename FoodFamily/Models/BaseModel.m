//
//  NetDataEngine.m
//  FoodFamily
//
//  Created by qianfeng on 15/12/21.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //NSLog(@"捕获到未定义的key=[%@]",key);
}

- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
