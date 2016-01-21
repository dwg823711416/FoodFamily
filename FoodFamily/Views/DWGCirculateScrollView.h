//
//  DWGCirculateScrollView.h
//  DWGScrollView
//
//  Created by qianfeng on 16/1/9.
//  Copyright © 2016年 DuWeiGuo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^tapBlock) (NSInteger index);
@interface DWGCirculateScrollView : UIScrollView<UIScrollViewDelegate>
@property (retain,nonatomic,readonly)  UIPageControl * pageControl;
@property (retain,nonatomic,readwrite) NSArray       * imageNameArray;
@property (retain,nonatomic,readwrite) NSArray       * imageUrlNameArray;

@property (nonatomic,copy)             tapBlock      block;
- (void) obtainImageNameArray:(NSArray *)imageNameArray imageUrlArray:(NSArray *)imageUrlArray;


@end
