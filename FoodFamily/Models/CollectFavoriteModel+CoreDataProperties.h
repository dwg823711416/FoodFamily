//
//  CollectFavoriteModel+CoreDataProperties.h
//  FoodFamily
//
//  Created by qianfeng on 15/12/23.
//  Copyright © 2015年 杜卫国. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CollectFavoriteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectFavoriteModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *vegetable_id;
@property (nullable, nonatomic, retain) NSString *is_purchase;
@property (nullable, nonatomic, retain) NSString *is_collect;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *fittingRestriction;
@property (nullable, nonatomic, retain) NSString *method;
@property (nullable, nonatomic, retain) NSString *imagePathLandscape;
@property (nullable, nonatomic, retain) NSString *englishName;
@property (nullable, nonatomic, retain) NSString *imagePathPortrait;
@property (nullable, nonatomic, retain) NSString *imagePathThumbnails;
@property (nullable, nonatomic, retain) NSString *catalogId;
@property (nullable, nonatomic, retain) NSString *price;
@property (nullable, nonatomic, retain) NSString *clickCount;
@property (nullable, nonatomic, retain) NSString *isCelebritySelf;
@property (nullable, nonatomic, retain) NSString *agreementAmount;
@property (nullable, nonatomic, retain) NSString *downloadCount;
@property (nullable, nonatomic, retain) NSString *materialVideoPath;
@property (nullable, nonatomic, retain) NSString *productionProcessPath;
@property (nullable, nonatomic, retain) NSString *vegetableCookingId;
@property (nullable, nonatomic, retain) NSString *cookingWay;
@property (nullable, nonatomic, retain) NSString *timeLength;
@property (nullable, nonatomic, retain) NSString *taste;
@property (nullable, nonatomic, retain) NSString *cookingMethod;
@property (nullable, nonatomic, retain) NSString *effect;
@property (nullable, nonatomic, retain) NSString *fittingCrowd;

@end

NS_ASSUME_NONNULL_END
