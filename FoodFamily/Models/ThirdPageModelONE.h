//
//  ThirdPageModelONE.h
//  FoodFamily
//
//  Created by qianfeng on 16/1/21.
//  Copyright © 2016年 杜卫国. All rights reserved.
//

#import "BaseModel.h"

@interface ThirdPageModelONE : BaseModel
//"id": "22981",
//"uid": "84674",
//"author": "老杨的厨房",
//"title": "鸡肉小土豆贴饼子",
//"message": "土鸡 、小土豆、葱姜蒜、干辣椒、八角、花椒、白酒、玉米面团、盐、五香粉、味精、糖、老抽。",
//"mainingredient": "土鸡 、小土豆、葱姜蒜、干辣椒、八角、花椒、白酒、玉米面团、盐、五香粉、味精、糖、老抽。",
//"cover": "http://i3.2meiwei.com/attachment/r/2011/04/30/c240_201104301408069.jpg",
//"ccover": "http://i3.2meiwei.com/attachment/r/2011/04/30/c240_201104301408069.jpg",
@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * uid;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * message;
@property (nonatomic,copy) NSString * cover;

+ (NSMutableArray*)parseRespondsData:(NSDictionary*)dictionary;
@end
