//
//  CollectFavoriteModel3+CoreDataProperties.h
//  
//
//  Created by qianfeng on 16/1/25.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CollectFavoriteModel3.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectFavoriteModel3 (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *uid;
@property (nullable, nonatomic, retain) NSString *subiect;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *level;
@property (nullable, nonatomic, retain) NSString *during;
@property (nullable, nonatomic, retain) NSString *cuisine;
@property (nullable, nonatomic, retain) NSString *technics;
@property (nullable, nonatomic, retain) NSString *basefood;
@property (nullable, nonatomic, retain) NSString *ingredient;
@property (nullable, nonatomic, retain) NSString *mainingredient;
@property (nullable, nonatomic, retain) NSString *message;
@property (nullable, nonatomic, retain) NSString *tips;
@property (nullable, nonatomic, retain) NSString *cover;
@property (nullable, nonatomic, retain) NSNumber *stepcount;

@end

NS_ASSUME_NONNULL_END
