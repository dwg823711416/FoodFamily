//
//  FourthCollectTableViewCell.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/12.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "FourthCollectTableViewCell.h"
@interface FourthCollectTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *collectImageView;
@property (weak, nonatomic) IBOutlet UILabel *collectlable;

@end
@implementation FourthCollectTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)updateWithModel:(CollectFavoriteModel *)model{
    [self.collectImageView sd_setImageWithURL:[NSURL URLWithString:model.imagePathThumbnails]];
    self.collectlable.text = model.name;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
