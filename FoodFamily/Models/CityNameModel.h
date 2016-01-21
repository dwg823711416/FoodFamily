//
//  CityNameModel.h
//  FoodFamily
//
//  Created by qianfeng on 16/1/8.
//  Copyright © 2016年 杜卫国. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityNameModel : NSObject
@property (nonatomic ,copy)NSArray  * 市;
@property (nonatomic ,copy)NSString * 省;

+ (NSArray *) analysisData:(NSData *)data;
@end
