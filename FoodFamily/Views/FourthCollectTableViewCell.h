//
//  FourthCollectTableViewCell.h
//  oneBook1.0
//
//  Created by qianfeng on 15/12/12.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectFavoriteModel.h"
#import "CollectFavoriteModel3.h"
@interface FourthCollectTableViewCell : UITableViewCell
- (void)updateWithModel:(CollectFavoriteModel *)model;
- (void)updateWithThirdBaseModel:(CollectFavoriteModel3 *)model;
@end
