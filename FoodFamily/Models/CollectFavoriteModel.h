//
//  CollectFavoriteModel.h
//  FoodFamily
//
//  Created by qianfeng on 15/12/23.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FirstPageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CollectFavoriteModel : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (void)setUpWith:(FirstPageModel*)model;
@end

NS_ASSUME_NONNULL_END

#import "CollectFavoriteModel+CoreDataProperties.h"
