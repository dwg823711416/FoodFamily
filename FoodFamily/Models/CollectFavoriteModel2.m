//
//  CollectFavoriteModel2.m
//  
//
//  Created by qianfeng on 16/1/25.
//
//

#import "CollectFavoriteModel2.h"

@implementation CollectFavoriteModel2
- (void)setUpWithModel2:(ThirdCookModel *)model{
    //@dynamic id;
    //@dynamic rid;
    //@dynamic note;
    //@dynamic pic;
    //@dynamic idx;
    self.id   = model.id;
    self.rid  = model.rid;
    self.note = model.note;
    self.pic  = model.pic;
    self.idx  = model.idx;


}


@end
