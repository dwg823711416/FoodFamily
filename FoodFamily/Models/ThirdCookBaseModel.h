//
//  ThirdCookBaseModel.h
//  FoodFamily
//
//  Created by qianfeng on 16/1/22.
//  Copyright © 2016年 杜卫国. All rights reserved.
//

#import "BaseModel.h"

@interface ThirdCookBaseModel : BaseModel
@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * uid;
@property (nonatomic,copy) NSString * subiect;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * level;
@property (nonatomic,copy) NSString * during;
@property (nonatomic,copy) NSString * cuisine;
@property (nonatomic,copy) NSString * technics;
@property (nonatomic,copy) NSString * basefood;
@property (nonatomic,copy) NSString * ingredient;
@property (nonatomic,copy) NSString * mainingredient;
@property (nonatomic,copy) NSString * message;
@property (nonatomic,copy) NSString * tips;
@property (nonatomic)      NSArray  * steps;
@property (nonatomic)      NSString * cover;
+ (NSMutableArray*)parseRespondsData:(NSDictionary*)dictionary;
@end
