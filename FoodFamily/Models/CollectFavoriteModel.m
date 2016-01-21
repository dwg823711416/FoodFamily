//
//  CollectFavoriteModel.m
//  FoodFamily
//
//  Created by qianfeng on 15/12/23.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "CollectFavoriteModel.h"

@implementation CollectFavoriteModel

// Insert code here to add functionality to your managed object subclass
- (void)setUpWith:(FirstPageModel*)model{
    NSLog(@"%@",model.vegetable_id);
    self.vegetable_id          = model.vegetable_id;
    self.is_purchase           = model.is_purchase;
    self.is_collect            = model.is_collect;
    self.name                  = model.name;
    self.fittingRestriction    = model.fittingRestriction;
    self.method                = model.method;
    self.englishName           = model.englishName;
    self.imagePathLandscape    = model.imagePathLandscape;
    self.imagePathPortrait     = model.imagePathPortrait;
    self.imagePathThumbnails   = model.imagePathThumbnails;
    self.catalogId             = model.catalogId;
    self.price                 = model.price;
    self.clickCount            = model.clickCount;
    self.isCelebritySelf       = model.isCelebritySelf;
    self.agreementAmount       = model.agreementAmount;
    self.downloadCount         = model.downloadCount;
    self.materialVideoPath     = model.materialVideoPath;
    self.productionProcessPath = model.productionProcessPath;
    self.vegetableCookingId    = model.vegetableCookingId;
    self.cookingWay            = model.cookingWay;
    self.timeLength            = model.timeLength;
    self.taste                 = model.taste;
    self.cookingMethod         = model.cookingWay;
    self.effect                = model.effect;
    self.fittingCrowd          = model.fittingCrowd;
}
@end
