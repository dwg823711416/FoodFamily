//
//  VideoViewController.h
//  meishiwu
//
//  Created by qianfeng on 15/12/20.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerView.h"
@interface VideoViewController : UIViewController
@property (weak, nonatomic) IBOutlet PlayerView *playView;
@property (weak, nonatomic) IBOutlet UISlider   *slider;
@property (nonatomic,copy)  NSString            *voidUrl;

@end
