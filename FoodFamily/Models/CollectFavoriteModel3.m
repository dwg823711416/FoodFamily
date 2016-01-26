//
//  CollectFavoriteModel3.m
//  
//
//  Created by qianfeng on 16/1/25.
//
//

#import "CollectFavoriteModel3.h"

@implementation CollectFavoriteModel3
- (void)setUpWithModel3:(ThirdCookBaseModel*)model{
    self.id             = model.id;
    self.uid            = model.uid;
    self.subiect        = model.subiect;
    self.title          = model.title;
    self.level          = model.level;
    self.during         = model.during;
    self.cuisine        = model.cuisine;
    self.technics       = model.technics;
    self.basefood       = model.basefood;
    self.ingredient     = model.ingredient;
    self.mainingredient = model.mainingredient;
    self.message        = model.message;
    self.tips           = model.tips;
    self.cover          = model.cover;
    self.stepcount      = model.stepcount;

}
// Insert code here to add functionality to your managed object subclass

@end
