//
//  FirstPageModel.h
//  FoodFamily
//
//  Created by qianfeng on 15/12/21.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "BaseModel.h"

@interface FirstPageModel : BaseModel

@property(nonatomic,copy)NSString *vegetable_id;
@property(nonatomic,copy)NSString *is_purchase;
@property(nonatomic,copy)NSString *is_collect;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *fittingRestriction;
@property(nonatomic,copy)NSString *method;
@property(nonatomic,copy)NSString *englishName;
@property(nonatomic,copy)NSString *imagePathLandscape;
@property(nonatomic,copy)NSString *imagePathPortrait;
@property(nonatomic,copy)NSString *imagePathThumbnails;
@property(nonatomic,copy)NSString *catalogId;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *clickCount;
@property(nonatomic,copy)NSString *isCelebritySelf;
@property(nonatomic,copy)NSString *agreementAmount;
@property(nonatomic,copy)NSString *downloadCount;
@property(nonatomic,copy)NSString *materialVideoPath;
@property(nonatomic,copy)NSString *productionProcessPath;
@property(nonatomic,copy)NSString *vegetableCookingId;
@property(nonatomic,copy)NSString *cookingWay;
@property(nonatomic,copy)NSString *timeLength;
@property(nonatomic,copy)NSString *taste;
@property(nonatomic,copy)NSString *cookingMethod;
@property(nonatomic,copy)NSString *effect;
@property(nonatomic,copy)NSString *fittingCrowd;

+ (NSMutableArray*)parseRespondsData:(NSDictionary*)dictionary;
@end
