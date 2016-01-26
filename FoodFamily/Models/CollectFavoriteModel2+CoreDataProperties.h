//
//  CollectFavoriteModel2+CoreDataProperties.h
//  
//
//  Created by qianfeng on 16/1/25.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CollectFavoriteModel2.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectFavoriteModel2 (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *rid;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSString *pic;
@property (nullable, nonatomic, retain) NSNumber *idx;

@end

NS_ASSUME_NONNULL_END
