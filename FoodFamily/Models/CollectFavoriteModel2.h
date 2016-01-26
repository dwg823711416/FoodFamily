//
//  CollectFavoriteModel2.h
//  
//
//  Created by qianfeng on 16/1/25.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ThirdCookModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CollectFavoriteModel2 : NSManagedObject

- (void)setUpWithModel2:(ThirdCookModel *)model;

@end

NS_ASSUME_NONNULL_END

#import "CollectFavoriteModel2+CoreDataProperties.h"
